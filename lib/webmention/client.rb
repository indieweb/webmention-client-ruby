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
        endpoint = Webmention::Endpoint.discover(link)

        next unless endpoint

        sent_mentions_count += 1 if Webmention::Client.send_mention(endpoint, url, link)
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
      # Ensure the endpoint is an absolute URL
      endpoint = absolute_endpoint(endpoint, target)

      begin
        response = HTTParty.post(endpoint, body: { source: source, target: target })

        return response if full_response

        return response.code == 200 || response.code == 202
      rescue
        return false
      end
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
      return endpoint if Webmention::Client.valid_http_url?(endpoint)

      URI.join(url, endpoint).to_s
    end
  end
end
