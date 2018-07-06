module Webmention
  module Endpoint
    class << self
      # Keeping for convenience of test suite passage
      def discover_webmention_endpoint_from_header(header)
        Discover.endpoint_from_headers(header) || false
      end

      # Keeping for convenience of test suite passage
      def discover_webmention_endpoint_from_html(html)
        Discover.endpoint_from_body(html) || false
      end

      def supports_webmention?(url)
        return false unless Webmention::Client.valid_http_url?(url)

        Discover.new(url).endpoint
      end
    end
  end
end
