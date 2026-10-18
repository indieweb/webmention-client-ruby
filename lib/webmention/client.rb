# frozen_string_literal: true

module Webmention
  class Client
    # @return [Url]
    attr_reader :source_url

    # @return [Url]
    attr_reader :vouch_url

    # Create a new {Client}.
    #
    # @example
    #   Webmention::Client.new("https://jgarber.example/posts/100")
    #
    # @example
    #   Webmention::Client.new("https://jgarber.example/posts/100", vouch: "https://tantek.example/notes/1")
    #
    # @param source [String, HTTP::URI, #to_s]
    #   An absolute URL representing a source document.
    # @param vouch [String, HTTP::URI, #to_s]
    #   An absolute URL representing a document vouching for the source document.
    #   See https://indieweb.org/Vouch for additional details.
    def initialize(source, vouch: nil)
      @source_url = Url.new(source)
      @vouch_url = Url.new(vouch)
    end

    # @return [String]
    def inspect
      "#<#{self.class}:#{format("%#0x", object_id)} " \
        "source_url: #{source_url} " \
        "vouch_url: #{vouch_url}>"
    end

    # Retrieve unique URLs mentioned by this client's source URL.
    #
    # @example
    #   client = Webmention::Client.new("https://jgarber.example/posts/100")
    #   client.mentioned_urls
    #
    # @raise [Burly::UnsupportedMimeType]
    #   Raised when response is of an unsupported MIME type.
    #
    # @return [Array<String>]
    def mentioned_urls
      response = source_url.response

      response
        .mentioned_urls
        .lazy
        .reject { |url| url.match(/^#{response.uri}(?:#.*)?$/) }
        .sort
    end

    # Send a webmention from this client's source URL to a target URL.
    #
    # @example
    #   client = Webmention::Client.new("https://jgarber.example/posts/100")
    #   client.send_webmention("https://aaronpk.example/notes/1")
    #
    # @param target [String, HTTP::URI, #to_s]
    #   An absolute URL representing a target document.
    #
    # @return [Response, ErrorResponse]
    def send_webmention(target)
      target_url = Url.new(target)
      endpoint = target_url.webmention_endpoint
      response = target_url.response

      # A Webmention endpoint exists. Send the request and return the response.
      return Request.new(:post, endpoint, **request_options_for(target)).perform unless endpoint.nil?

      # An error was encountered fetching the target URL. Return the response.
      return response unless response.ok?

      # No Webmention endpoint exists. Return a new ErrorResponse.
      ErrorResponse.new("No Webmention endpoint found for target URL #{target}", response.request)
    end

    # Send webmentions from this client's source URL to multiple target URLs.
    #
    # @example
    #   client = Webmention::Client.new("https://jgarber.example/posts/100")
    #   targets = ["https://aaronpk.example/notes/1", "https://adactio.example/notes/1"]
    #   client.send_webmentions(targets)
    #
    # @param targets [Array<String, HTTP::URI, #to_s>]
    #   An array of absolute URLs representing multiple target documents.
    #
    # @return [Array<Response, ErrorResponse>]
    def send_webmentions(*targets)
      targets.map { |target| send_webmention(target) }
    end

    # Verify that this client's source URL links to a target URL.
    #
    # @param target [String, HTTP::URI, #to_s]
    #   An absolute URL representing a target document.
    #
    # @raise (see Client#mentioned_urls)
    #
    # @return [Verification]
    def verify_webmention(target)
      Verification.new(source_url, Url.new(target), vouch_url: vouch_url)
    end

    private

    # @param target [String, HTTP::URI, #to_s]
    #
    # @return [Hash{Symbol => String}]
    def request_options_for(target)
      opts = {
        source: source_url,
        target: target,
        vouch: vouch_url,
      }

      opts.transform_values! { |value| value.to_s.strip }
      opts.reject! { |_, value| value.empty? }

      { form: opts }
    end
  end
end
