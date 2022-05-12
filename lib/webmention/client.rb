# frozen_string_literal: true

module Webmention
  class Client
    @registered_parsers = {}

    class << self
      # @api private
      attr_reader :registered_parsers
    end

    # @return [Webmention::Url]
    attr_reader :source_url

    # @api private
    def self.register_parser(klass)
      klass.mime_types.each { |mime_type| @registered_parsers[mime_type] = klass }
    end

    # Create a new Webmention::Client.
    #
    # @example
    #   client = Webmention::Client.new('https://jgarber.example/posts/100')
    #
    # @param source [String, HTTP::URI, #to_s]
    #   An absolute URL representing a source document.
    #
    # @return [Webmention::Client]
    def initialize(source)
      @source_url = Url.new(source)
    end

    # :nocov:
    # @return [String]
    def inspect
      "#<#{self.class}:#{format('%#0x', object_id)} " \
        "source_url: #{source_url.uri}>"
    end
    # :nocov:

    # Retrieve unique URLs mentioned by this client's source URL.
    #
    # @example
    #   client = Webmention::Client.new('https://jgarber.example/posts/100')
    #   client.mentioned_urls
    #
    # @raise [NoMethodError] Occurs when response is a Webmention::ErrorResponse.
    # @raise [KeyError] Occurs when response if of an unsupported MIME type.
    #
    # @return [Array<String>]
    def mentioned_urls
      self.class
          .registered_parsers
          .fetch(source_url.response.mime_type)
          .new(source_url.response.body, source_url.response.uri)
          .results
          .uniq
          .sort
    end

    # Send a webmention from this client's source URL to a target URL.
    #
    # @example
    #   client = Webmention::Client.new('https://jgarber.example/posts/100')
    #   client.send_webmention('https://aaronpk.example/notes/1')
    #
    # @param target [String, HTTP::URI, #to_s]
    #   An absolute URL representing a target document.
    #
    # @return [Webmention::Response, Webmention::ErrorResponse]
    def send_webmention(target)
      target_url = Url.new(target)

      # A Webmention endpoint exists. Send the request and return the response.
      if target_url.webmention_endpoint?
        return Request.post(target_url.webmention_endpoint, source: source_url.to_s, target: target.to_s)
      end

      # An error was encountered fetching the target URL. Return the response.
      return target_url.response unless target_url.response.ok?

      # No Webmention endpoint exists. Return a new ErrorResponse.
      ErrorResponse.new("No webmention endpoint found for target URL #{target}", target_url.response.request)
    end

    # Send webmentions from this client's source URL to multiple target URLs.
    #
    # @example
    #   client = Webmention::Client.new('https://jgarber.example/posts/100')
    #   targets = ['https://aaronpk.example/notes/1', 'https://adactio.example/notes/1']
    #   client.send_webmentions(targets)
    #
    # @param *targets [Array<String, HTTP::URI, #to_s>]
    #   An array of absolute URLs representing multiple target documents.
    #
    # @return [Array<Webmention::Response, Webmention::ErrorResponse>]
    def send_webmentions(*targets)
      targets.map { |target| send_webmention(target) }
    end
  end
end
