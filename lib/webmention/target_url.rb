# frozen_string_literal: true

module Webmention
  class TargetUrl
    # @return [HTTP::URI]
    attr_reader :target_uri

    # @param target [String, HTTP::URI, #to_s]
    #   An absolute URL representing the target document
    def initialize(target)
      @target_uri = HTTP::URI.parse(target.to_s)
    end

    # :nocov:
    # @return [String]
    def inspect
      "#<#{self.class}:#{format('%#0x', object_id)} " \
        "target_uri: #{target_uri}>"
    end
    # :nocov:

    # @return [Webmention::Response, Webmention::ErrorResponse]
    def response
      @response ||= Request.get(target_uri)
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
