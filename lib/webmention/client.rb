
module Webmention
  class Client
    @url = nil

    def initialize(url)
      @url = url
    end

    def send_supported_mentions
      puts "stub"
      0
    end
  end
end
