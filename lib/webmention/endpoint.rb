module Webmention
  module Endpoint
    class << self
      def discover(url)
        return false unless Webmention::Client.valid_http_url?(url)

        Discover.new(url).endpoint
      end

      # Keeping for convenience of test suite passage
      def discover_webmention_endpoint_from_header(header)
        Discover.endpoint_from_headers(header) || false
      end

      # Keeping for convenience of test suite passage
      def discover_webmention_endpoint_from_html(html)
        Discover.endpoint_from_body(html) || false
      end
    end
  end
end
