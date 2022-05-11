# frozen_string_literal: true

module Webmention
  module Parsers
    class PlaintextParser < Parser
      @mime_types = ['text/plain']

      Client.register_parser(self)

      # @return [Array<String>] An array of absolute URLs.
      def results
        @results ||= URI.extract(response_body, %w[http https])
      end
    end
  end
end
