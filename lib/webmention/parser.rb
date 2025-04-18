# frozen_string_literal: true

module Webmention
  # @api private
  class Parser
    URI_REGEXP = URI::DEFAULT_PARSER.make_regexp(["http", "https"]).freeze

    public_constant :URI_REGEXP

    class << self
      # @return [Array<String>]
      attr_reader :mime_types
    end

    # @param response_body [HTTP::Response::Body, String, #to_s]
    # @param response_uri [String, HTTP::URI, #to_s]
    def initialize(response_body, response_uri)
      @response_body = response_body.to_s
      @response_uri = HTTP::URI.parse(response_uri.to_s)
    end

    private

    # @return [String]
    attr_reader :response_body

    # @return [HTTP::URI]
    attr_reader :response_uri
  end
end
