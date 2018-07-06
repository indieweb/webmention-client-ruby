module Webmention
  module Endpoint
    class Discover
      HTTP_PARTY_OPTS = {
        headers: {
          'Accept' => '*/*',
          'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/29.0.1547.57 Safari/537.36 (https://rubygems.org/gems/webmention)'
        },
        timeout: 3
      }.freeze

      attr_reader :url

      def initialize(url)
        @url = url
      end

      def endpoint
        endpoint_from_http_request
      end

      def response
        @response ||= HTTParty.get(url, HTTP_PARTY_OPTS)
      rescue EOFError, Errno::ECONNRESET
      end

      def self.endpoint_from_body(html)
        doc = Nokogiri::HTML(html)

        if !doc.css('[rel~="webmention"]').css('[href]').empty?
          doc.css('[rel~="webmention"]').css('[href]').attribute('href').value
        elsif !doc.css('[rel="http://webmention.org/"]').css('[href]').empty?
          doc.css('[rel="http://webmention.org/"]').css('[href]').attribute('href').value
        elsif !doc.css('[rel="http://webmention.org"]').css('[href]').empty?
          doc.css('[rel="http://webmention.org"]').css('[href]').attribute('href').value
        end
      end

      def self.endpoint_from_headers(header)
        return unless header

        if (matches = header.match(/<([^>]+)>; rel="[^"]*\s?webmention\s?[^"]*"/))
          return matches[1]
        elsif (matches = header.match(/<([^>]+)>; rel=webmention/))
          return matches[1]
        elsif (matches = header.match(/rel="[^"]*\s?webmention\s?[^"]*"; <([^>]+)>/))
          return matches[1]
        elsif (matches = header.match(/rel=webmention; <([^>]+)>/))
          return matches[1]
        elsif (matches = header.match(%r{<([^>]+)>; rel="http://webmention\.org/?"}))
          return matches[1]
        elsif (matches = header.match(%r{rel="http://webmention\.org/?"; <([^>]+)>}))
          return matches[1]
        end
      end

      def endpoint_from_http_request
        @endpoint_from_http_request ||= self.class.endpoint_from_headers(response.headers['link']) || self.class.endpoint_from_body(response.body.to_s) || nil
      end
    end
  end
end
