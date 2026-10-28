# frozen_string_literal: true

module Webmention
  # An interface representing a parsed URL and its {Response}.
  #
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

    # @!visibility private
    # simplecov:disable
    def inspect
      "#<#{self.class}:#{format("%#0x", object_id)} " \
        "uri: #{uri}>"
    end
    # simplecov:enable

    # @return [Response, ErrorResponse]
    def response
      @response ||= Request.new(:get, uri).perform
    end

    # @return [String, nil]
    def webmention_endpoint
      @webmention_endpoint ||=
        if response.ok?
          IndieWeb::Endpoints::Parser
            .new(
              body: response.body,
              headers: response.headers.get("link"),
              mime_type: response.mime_type,
              uri: response.uri
            )
            .to_h[:webmention]
        end
    end
  end
end
