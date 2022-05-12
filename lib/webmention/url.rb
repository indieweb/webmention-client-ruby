# frozen_string_literal: true

module Webmention
  class Url
    extend Forwardable

    # @return [HTTP::URI]
    attr_reader :uri

    # @!method
    #   @return [String]
    def_delegator :uri, :to_s

    # Create a new Webmention::Url.
    #
    # @param url [String, HTTP::URI, #to_s] An absolute URL.
    #
    # @return [Webmention::Url]
    def initialize(url)
      @uri = HTTP::URI.parse(url.to_s)
    end

    # :nocov:
    # @return [String]
    def inspect
      "#<#{self.class}:#{format('%#0x', object_id)} " \
        "uri: #{uri}>"
    end
    # :nocov:

    # @return [Webmention::Response, Webmention::ErrorResponse]
    def response
      @response ||= Request.get(uri)
    end

    # @return [String, nil]
    def webmention_endpoint
      @webmention_endpoint ||= IndieWeb::Endpoints::Parser.new(response).results[:webmention] if response.ok?
    end

    # @return [Boolean]
    def webmention_endpoint?
      !webmention_endpoint.nil?
    end
  end
end
