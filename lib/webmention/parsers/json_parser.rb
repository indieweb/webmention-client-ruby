# frozen_string_literal: true

module Webmention
  module Parsers
    # @api private
    class JsonParser < Parser
      @mime_types = ['application/json']

      Client.register_parser(self)

      # @return [Array<String>] An array of absolute URLs.
      def results
        @results ||= extract_urls_from(JSON.parse(response_body))
      end

      private

      # @param *objs [Array<Hash, Array, String, Integer, Boolean, nil>]
      #
      # @return [Array<String>]
      def extract_urls_from(*objs)
        objs.flat_map do |obj|
          return obj.flat_map { |value| extract_urls_from(value) }.compact if obj.is_a?(Array)
          return extract_urls_from(obj.values) if obj.is_a?(Hash)

          obj if obj.is_a?(String) && obj.match?(Parser::URI_REGEXP)
        end
      end
    end
  end
end
