# frozen_string_literal: true

module Webmention
  class Request
    # Defaults derived from Webmention specification examples.
    # @see https://www.w3.org/TR/webmention/#limits-on-get-requests
    HTTP_CLIENT_OPTS = {
      follow: {
        max_hops: 20
      },
      headers: {
        accept: '*/*',
        user_agent: 'Webmention Client (https://rubygems.org/gems/webmention)'
      },
      timeout_options: {
        connect_timeout: 5,
        read_timeout: 5
      }
    }.freeze

    private_constant :HTTP_CLIENT_OPTS

    # @return [Symbol]
    attr_reader :method

    # @return [HTTP::URI]
    attr_reader :uri

    # @return [Hash]
    attr_reader :options

    # Send an HTTP GET request to the supplied URL.
    #
    # @example
    #   Request.get('https://jgarber.example/posts/100')
    #
    # @param url [String]
    #
    # @return [Webmention::Response, Webmention::ErrorResponse]
    def self.get(url)
      new(:get, url).perform
    end

    # Send an HTTP POST request with form-encoded data to the supplied URL.
    #
    # @example
    #   Request.post(
    #     'https://aaronpk.example/webmention',
    #     source: 'https://jgarber.examples/posts/100',
    #     target: 'https://aaronpk.example/notes/1'
    #   )
    #
    # @param url [String]
    # @param options [Hash{Symbol => String}]
    # @option options [String] :source
    #   An absolute URL representing a source document.
    # @option options [String] :target
    #   An absolute URL representing a target document.
    #
    # @return [Webmention::Response, Webmention::ErrorResponse]
    def self.post(url, **options)
      new(:post, url, form: options).perform
    end

    # Create a new Webmention::Request.
    #
    # @param method [Symbol]
    # @param url [String]
    # @param options [Hash{Symbol => String}]
    # @option options [String] :source
    #   An absolute URL representing a source document.
    # @option options [String] :target
    #   An absolute URL representing a target document.
    #
    # @return [Webmention::Request]
    def initialize(method, url, **options)
      @method = method.to_sym
      @uri = HTTP::URI.parse(url.to_s)
      @options = options
    end

    # :nocov:
    # @return [String]
    def inspect
      "#<#{self.class}:#{format('%#0x', object_id)} " \
        "method: #{method.upcase}, " \
        "url: #{uri}>"
    end
    # :nocov:

    # Submit the Webmention::Request.
    #
    # @return [Webmention::Response, Webmention::ErrorResponse]
    def perform
      Response.new(client.request(method, uri, options), self)
    rescue HTTP::Error,
           OpenSSL::SSL::SSLError => e
      ErrorResponse.new(e.message, self)
    end

    private

    def client
      @client ||= HTTP::Client.new(HTTP_CLIENT_OPTS)
    end
  end
end
