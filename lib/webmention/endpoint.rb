module Webmention
  module Endpoint
    class << self
      def discover_webmention_endpoint_from_header(header)
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

        false
      end

      def discover_webmention_endpoint_from_html(html)
        doc = Nokogiri::HTML(html)

        if !doc.css('[rel~="webmention"]').css('[href]').empty?
          doc.css('[rel~="webmention"]').css('[href]').attribute('href').value
        elsif !doc.css('[rel="http://webmention.org/"]').css('[href]').empty?
          doc.css('[rel="http://webmention.org/"]').css('[href]').attribute('href').value
        elsif !doc.css('[rel="http://webmention.org"]').css('[href]').empty?
          doc.css('[rel="http://webmention.org"]').css('[href]').attribute('href').value
        else
          false
        end
      end

      def supports_webmention?(url)
        return false unless Webmention::Client.valid_http_url?(url)

        begin
          http_party_opts = {
            headers: {
              'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/29.0.1547.57 Safari/537.36 (https://rubygems.org/gems/webmention)',
              'Accept' => '*/*'
            },
            timeout: 3
          }

          response = HTTParty.get(url, http_party_opts)

          # First check the HTTP Headers
          link_headers = response.headers['link']

          unless link_headers.nil?
            endpoint = discover_webmention_endpoint_from_header(link_headers)

            return endpoint if endpoint
          end

          # Do we support webmention?
          endpoint = discover_webmention_endpoint_from_html(response.body.to_s)

          return endpoint if endpoint

          # TODO: Move to supports_pingback? method
          # Last chance, do we support Pingback?
          # if !doc.css('link[rel="pingback"]').empty?
          #   return doc.css('link[rel="pingback"]').attribute("href").value
          # end
        rescue EOFError
        rescue Errno::ECONNRESET
        end

        false
      end
    end
  end
end
