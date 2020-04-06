module Webmention
  module Parsers
    class BaseParser
      class << self
        attr_reader :mime_types
      end

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

      def response_url
        @response_url ||= @response.uri.to_s
      end
    end
  end
end
