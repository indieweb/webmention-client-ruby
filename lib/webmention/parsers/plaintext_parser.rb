# frozen_string_literal: true

module Webmention
  module Parsers
    # @api private
    class PlaintextParser < Parser
      @mime_types = ['text/plain']

      Client.register_parser(self)

      # @return [Array<String>] An array of absolute URLs.
      def results
        @results ||= URI::DEFAULT_PARSER.extract(response_body, %w[http https])
      end
    end
  end
end
