# frozen_string_literal: true

module Webmention
  # @api private
  class Url
    extend Forwardable

    # @return [HTTP::URI]
    attr_reader :uri

    # @!method
    #   @return [String]
    def_delegator :uri, :to_s

    # Create a new {Url}.
    #
    # @param url [String, HTTP::URI, #to_s] An absolute URL.
    def initialize(url)
      @uri = HTTP::URI.parse(url.to_s)
    end

    # @return [String]
    def inspect
      "#<#{self.class}:#{format("%#0x", object_id)} " \
        "uri: #{uri}>"
    end

    # @return [Response, ErrorResponse]
    def response
      @response ||= Request.new(:get, uri).perform
    end

    # @return [String, nil]
    def webmention_endpoint
      @webmention_endpoint ||= IndieWeb::Endpoints::Parser.new(response).to_h[:webmention] if response.ok?
    end
  end
end
