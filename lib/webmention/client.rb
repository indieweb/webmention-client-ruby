# frozen_string_literal: true

module Webmention
  class Client
    @registered_parsers = {}

    class << self
      # @api private
      attr_reader :registered_parsers
    end

    # @return [HTTP::URI]
    attr_reader :source_uri

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
    #   An absolute URL representing the source document.
    #
    # @return [Webmention::Client]
    def initialize(source)
      @source_uri = HTTP::URI.parse(source.to_s)
    end

    # :nocov:
    # @return [String]
    def inspect
      "#<#{self.class}:#{format('%#0x', object_id)} " \
        "source_uri: #{source_uri}>"
    end
    # :nocov:

    # Send a webmention from this client's source URL to the target URL.
    #
    # @example
    #   client = Webmention::Client.new('https://jgarber.example/posts/100')
    #   client.send_webmention('https://aaronpk.example/notes/1')
    #
    # @param target [String, HTTP::URI, #to_s]
    #   An absolute URL representing the target document.
    #
    # @return [Webmention::Response, Webmention::ErrorResponse]
    def send_webmention(target)
      target_url = TargetUrl.new(target)

      # A Webmention endpoint exists. Send the request and return the response.
      if target_url.webmention_endpoint?
        return Request.post(target_url.webmention_endpoint, source: source_uri.to_s, target: target.to_s)
      end

      # An error was encountered fetching the target URL. Return the response.
      return target_url.response unless target_url.response.ok?

      # No Webmention endpoint exists. Return a new ErrorResponse.
      ErrorResponse.new("No webmention endpoint found for target URL #{target}", target_url.response.request)
    end

    # Send webmentions from this client's source URL to the target URLs.
    #
    # @example
    #   client = Webmention::Client.new('https://jgarber.example/posts/100')
    #   targets = ['https://aaronpk.example/notes/1', 'https://adactio.example/notes/1']
    #   client.send_webmentions(targets)
    #
    # @param targets [Array<String, HTTP::URI, #to_s>]
    #   An array of absolute URLs representing the target documents.
    #
    # @return [Array<Webmention::Response, Webmention::ErrorResponse>]
    def send_webmentions(*targets)
      targets.map { |target| send_webmention(target) }
    end
  end
end
