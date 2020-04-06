require 'absolutely'
require 'addressable/uri'
require 'http'
require 'indieweb/endpoints'
require 'nokogiri'

require 'webmention/version'
require 'webmention/exceptions'

require 'webmention/client'
require 'webmention/registerable'

require 'webmention/parsers'
require 'webmention/parsers/html_parser'

require 'webmention/services/http_request_service'

module Webmention
  class << self
    def client(source)
      Client.new(source)
    end

    def send_mention(source, target)
      client(source).send_mention(target)
    end
  end
end
