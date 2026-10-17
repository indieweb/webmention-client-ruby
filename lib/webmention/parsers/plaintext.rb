# frozen_string_literal: true

module Webmention
  module Parsers
    # @api private
    class Plaintext < Base
      @mime_types = ["text/plain"]

      # Parse a plaintext document for absolute URLs.
      #
      # @return [Array<String>] An array of absolute URLs.
      def parse
        uri_parser.extract(@document, ["http", "https"])
      end
    end
  end
end
