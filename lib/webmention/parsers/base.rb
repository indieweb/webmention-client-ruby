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

      # @param document [HTTP::Response::Body, String, #to_s]
      def initialize(document, **_kwargs)
        @document = document.to_s
      end

      # @raise [NotImplementedError]
      def parse
        raise NotImplementedError
      end

      private

      def uri_parser
        @uri_parser ||= URI::RFC2396_Parser.new
      end

      def uri_regexp
        @uri_regexp ||= uri_parser.make_regexp(["http", "https"])
      end
    end
  end
end
