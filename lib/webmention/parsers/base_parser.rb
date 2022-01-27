# frozen_string_literal: true

module Webmention
  module Parsers
    class BaseParser
      class << self
        attr_reader :mime_types
      end

      def initialize(body:, mime_type:, uri:)
        @response_body = body.to_str
        @response_url = uri.to_str

        return if self.class.mime_types.include?(mime_type)

        raise UnsupportedMimeTypeError, "Unsupported MIME Type: #{response.mime_type}"
      end

      private

      attr_reader :response_body, :response_url
    end
  end
end
