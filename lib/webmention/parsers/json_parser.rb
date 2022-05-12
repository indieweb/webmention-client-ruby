# frozen_string_literal: true

module Webmention
  module Parsers
    # @api private
    class JsonParser < Parser
      @mime_types = ['application/json']

      Client.register_parser(self)

      # @return [Array<String>] An array of absolute URLs.
      def results
        @results ||= UrlExtractor.extract(doc)
      end

      private

      # @return [Array, Hash]
      def doc
        @doc ||= JSON.parse(response_body)
      end

      module UrlExtractor
        # @param *objs [Array<Hash, Array, String, Integer, Boolean, nil>]
        #
        # @return [Array<String>]
        def self.extract(*objs)
          objs.flat_map { |obj| values_from(obj) }
        end

        # @param obj [Hash, Array, String, Integer, Boolean, nil]
        #
        # @return [Array<String>, String, nil]
        def self.values_from(obj)
          return obj.flat_map { |value| extract(value) }.compact if obj.is_a?(Array)
          return extract(obj.values) if obj.is_a?(Hash)

          obj if obj.is_a?(String) && obj.match?(Parser::URI_REGEXP)
        end
      end
    end
  end
end
