# frozen_string_literal: true

module Webmention
  module Parsers
    # @api private
    class Json < Base
      @mime_types = ["application/json"]

      # Parse a JSON document for string values whose content are absolute URLs.
      #
      # @return [Array<String>] An array of absolute URLs.
      def parse
        recursive_parse(JSON.parse(@document)).to_a.compact
      end

      private

      def recursive_parse(*objs)
        objs.lazy.flat_map do |obj|
          case obj
          when Array  then recursive_parse(*obj)
          when Hash   then recursive_parse(obj.values)
          when String then obj if obj.match?(uri_regexp)
          end
        end
      end
    end
  end
end
