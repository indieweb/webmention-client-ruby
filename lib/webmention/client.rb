module Webmention
  class Client
    # Public: Returns a URI of the url initialized with.
    attr_reader :url

    # Public: Returns an array of links contained within the url.
    attr_reader :links

    # Public: Create a new client
    #
    # url - The url you want us to crawl.
    def initialize(url)
      @url = URI.parse(url)
      @links ||= Set.new

      raise ArgumentError, "`#{@url}` is not a valid URL." unless Webmention::Client.valid_http_url?(@url)
    end

    # Public: Crawl the url this client was initialized with.
    #
    # Returns the number of links found.
    def crawl
      @links ||= Set.new

      raise ArgumentError, 'URL cannot be nil.' if @url.nil?

      Nokogiri::HTML(open(url)).css('.h-entry a').each do |link|
        link = link.attribute('href').to_s

        @links.add(link) if Webmention::Client.valid_http_url?(link)
      end

      @links.count
    end

    # Public: Sends mentions to each of the links found in the page.
    #
    # Returns the number of links mentioned.
    def send_mentions
      crawl if links.nil? || links.empty?

      sent_mentions_count = 0

      links.each do |link|
        endpoint = Webmention::Client.supports_webmention?(link)

        if endpoint
          sent_mentions_count += 1 if Webmention::Client.send_mention(endpoint, url, link)
        end
      end

      sent_mentions_count
    end

    # Public: Send a mention to an endoint about a link from a link.
    #
    # endpoint - URL to send mention to.
    # source - Source of mention (your page).
    # target - The link that was mentioned in the source page.
    #
    # Returns a boolean.
    def self.send_mention(endpoint, source, target, full_response = false)
      data = {
        source: source,
        target: target
      }

      # Ensure the endpoint is an absolute URL
      endpoint = absolute_endpoint(endpoint, target)

      begin
        response = HTTParty.post(endpoint, body: data)

        return response if full_response

        return response.code == 200 || response.code == 202
      rescue
        return false
      end
    end

    # Public: Fetch a url and check if it supports webmention
    #
    # url - URL to check
    #
    # Returns false if does not support webmention, returns string
    # of url to ping if it does.
    def self.supports_webmention?(url)
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

    def self.discover_webmention_endpoint_from_html(html)
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

    def self.discover_webmention_endpoint_from_header(header)
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

    # Public: Use URI to parse a url and check if it is HTTP or HTTPS.
    #
    # url - URL to check
    #
    # Returns a boolean.
    def self.valid_http_url?(url)
      url = URI.parse(url) if url.is_a?(String)

      url.is_a?(URI::HTTP) || url.is_a?(URI::HTTPS)
    end

    # Public: Takes an endpoint and ensures an absolute URL is returned
    #
    # endpoint - Endpoint which may be an absolute or relative URL
    # url - URL of the webmention
    #
    # Returns original endpoint if it is already an absolute URL; constructs
    # new absolute URL using relative endpoint if not
    def self.absolute_endpoint(endpoint, url)
      unless Webmention::Client.valid_http_url?(endpoint)
        endpoint = URI.join(url, endpoint).to_s
      end

      endpoint
    end
  end
end
