require 'absolutely'
require 'addressable/uri'
require 'http'
require 'indieweb/endpoints'
require 'nokogiri'

require 'webmention/version'
require 'webmention/exceptions'

require 'webmention/client'
require 'webmention/http_request'
require 'webmention/registerable'

require 'webmention/parsers'
require 'webmention/parsers/html_parser'

module Webmention
  def self.send_mention(source, target)
    Client.new(source).send_mention(target)
  end
end
