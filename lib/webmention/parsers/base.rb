# frozen_string_literal: true

module Webmention
  module Parsers
    # @api private
    class Base
      class << self
        # @return [Array<String>]
        attr_reader :mime_types
      end

      # @return [Array<Class>]
      def self.descendants
        ObjectSpace.each_object(Class).select { |klass| klass < self }
      end

      # @param response_body [HTTP::Response::Body, String, #to_s]
      # @param response_uri [String, HTTP::URI, #to_s]
      def initialize(response_body, response_uri)
        @response_body = response_body.to_s
        @response_uri = HTTP::URI.parse(response_uri.to_s)
      end

      # @raise [NotImplementedError]
      def parse
        raise NotImplementedError
      end

      private

      # @return [String]
      attr_reader :response_body

      # @return [HTTP::URI]
      attr_reader :response_uri

      def uri_parser
        @uri_parser ||= URI::RFC2396_Parser.new
      end

      def uri_regexp
        @uri_regexp ||= uri_parser.make_regexp(["http", "https"])
      end
    end
  end
end
