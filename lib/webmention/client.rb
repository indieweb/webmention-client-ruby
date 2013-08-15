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

      unless @url.is_a? URI::HTTP or @url.is_a? URI::HTTPS
        raise ArgumentError.new "url is not a valid HTTP or HTTPS URI."
      end
    end

    # Public: Crawl the url this client was initialized with.
    #
    # Returns the number of links found.
    def crawl
      doc = Nokogiri::HTML(open(self.url))
      @links = doc.css('a').map {|link| link.attribute('href').to_s }.sort.uniq.delete_if {|href| href.empty? }

      return @links.count
    end

    # Public: Sends mentions to each of the links found in the page.
    #
    # Returns the number of links mentioned.
    def send_mentions
      if self.links.empty?
        self.crawl
      end

      return 0
    end
  end
end
