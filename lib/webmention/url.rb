# frozen_string_literal: true

module Webmention
  class Url
    # @return [HTTP::URI]
    attr_reader :uri

    # @param target [String, HTTP::URI, #to_s] An absolute URL.
    def initialize(target)
      @uri = HTTP::URI.parse(target.to_s)
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
