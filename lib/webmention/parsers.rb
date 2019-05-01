module Webmention
  module Parsers
    extend Registerable

    class BaseParser
      def initialize(response)
        raise ArgumentError, "response must be an HTTP::Response (given #{response.class.name})" unless response.is_a?(HTTP::Response)

        @response = response

        raise UnsupportedMimeTypeError, "Unsupported MIME Type: #{response.mime_type}" unless self.class.mime_types.include?(response.mime_type)
      end

      def results
        @results ||= parse_response_body
      end

      private

      def response_body
        @response_body ||= @response.body.to_s
      end
    end
  end
end
