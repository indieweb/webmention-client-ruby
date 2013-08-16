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

      unless Webmention::Client.valid_http_url? @url
        raise ArgumentError.new "#{@url} is not a valid HTTP or HTTPS URI."
      end
    end

    # Public: Crawl the url this client was initialized with.
    #
    # Returns the number of links found.
    def crawl
      @links ||= Set.new
      if @url.nil?
        raise ArgumentError.new "url is nil."
      end

      Nokogiri::HTML(open(self.url)).css('a').each do |link|
        link = link.attribute('href').to_s
        if Webmention::Client.valid_http_url? link
          @links.add link
        end
      end

      return @links.count
    end

    # Public: Sends mentions to each of the links found in the page.
    #
    # Returns the number of links mentioned.
    def send_mentions
      if self.links.nil? or self.links.empty?
        self.crawl
      end

      p self.links.to_a.map {|a| Webmention::Client.supports_webmention? a }

      return 0
    end

    # Public: Curl a url and check if it supports webmention or pingbacks.
    #
    # url - URL to check
    #
    # Returns a boolean.
    def self.supports_webmention? url
      return false if !Webmention::Client.valid_http_url? url

      doc = nil

      begin
        uri = URI.parse(url)
        http = Net::HTTP.new(uri.host, uri.port)
        http.open_timeout = 3 # in seconds
        http.read_timeout = 3 # in seconds

        request = Net::HTTP::Get.new(uri.request_uri)
        request["User-Agent"] = "Ruby WebMention Gem"
        request["Accept"] = "*/*"

        response = http.request(request)

        if !response["Link"].nil? and response["Link"].matches %r{<(https?://[^>]+)>; rel="http://webmention.org/"}
          return true
        end

        doc = Nokogiri::HTML(response.body.to_s)

        if !doc.css('link[rel="webmention"]').empty?
          return true
        end

        if !doc.css('link[rel="pingback"]').empty?
          return true
        end

      rescue EOFError
      rescue Errno::ECONNRESET
      end

      return false
    end

    # Public: Use URI to parse a url and check if it is HTTP or HTTPS.
    #
    # url - URL to check
    #
    # Returns a boolean.
    def self.valid_http_url? url
      if url.is_a? String
        url = URI.parse(url)
      end

      return (url.is_a? URI::HTTP or url.is_a? URI::HTTPS)
    end
  end
end
