# frozen_string_literal: true

module Webmention
  # An interface for executing HTTP requests and generating {Response}s and
  # {ErrorResponse}s.
  #
  # @api private
  class Request
    # Set defaults derived from Webmention specification examples.
    #
    # @see https://www.w3.org/TR/webmention/#limits-on-get-requests
    #   W3C Webmention Recommendation § 4.2 Limits on GET requests
    HTTP_CLIENT_OPTS = {
      follow: {
        max_hops: 20,
      },
      headers: {
        accept: "*/*",
        user_agent: "Webmention Client (https://rubygems.org/gems/webmention)",
      },
      timeout_options: {
        connect_timeout: 5,
        read_timeout: 5,
      },
    }.freeze

    private_constant :HTTP_CLIENT_OPTS

    # @return [Symbol]
    attr_reader :method

    # @return [HTTP::URI]
    attr_reader :uri

    # @return [Hash]
    attr_reader :options

    # Create a new {Request}.
    #
    # @example
    #   Webmention::Request.new(:get, "https://jgarber.example/posts/100")
    #
    # @example
    #   Webmention::Request.new(
    #     :post,
    #     "https://aaronpk.example/webmention",
    #     form: {
    #       source: "https://jgarber.examples/posts/100",
    #       target: "https://aaronpk.example/notes/1",
    #       vouch: "https://tantek.example/notes/1",
    #     },
    #   )
    #
    # @see https://indieweb.org/Vouch
    #
    # @param method [Symbol]
    # @param url [String]
    # @param source (see Client#initialize)
    # @param target (see Client#send_webmention)
    # @param vouch (see Client#initialize)
    def initialize(method, url, source: nil, target: nil, vouch: nil)
      @method = method.to_sym
      @uri = HTTP::URI.parse(url.to_s)
      @options = {
        source: source,
        target: target,
        vouch: vouch,
      }
    end

    # @!visibility private
    # simplecov:disable
    def inspect
      "#<#{self.class}:#{format("%#0x", object_id)} " \
        "method: #{method.upcase}, " \
        "url: #{uri}>"
    end
    # simplecov:enable

    # Execute the {Request}.
    #
    # @return [Response, ErrorResponse]
    def perform
      Response.new(client.request(method, uri, **options), self)
    rescue HTTP::Error, OpenSSL::SSL::SSLError => e
      ErrorResponse.new(e.message, self)
    end

    private

    # @return [HTTP::Client]
    def client
      @client ||= HTTP::Client.new(HTTP_CLIENT_OPTS)
    end
  end
end
