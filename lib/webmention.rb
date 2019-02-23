require 'set'

require 'absolutely'
require 'addressable/uri'
require 'http'
require 'nokogiri'
require 'open-uri'
require 'set'
require 'webmention/endpoint'

require 'webmention/version'
require 'webmention/error'
require 'webmention/client'
require 'webmention/parser'
require 'webmention/parsers/html_parser'
require 'webmention/request'
require 'webmention/requests/get_request'
require 'webmention/requests/post_request'

module Webmention
  def self.send_mention(source, target)
    Client.new(source).send_mention(target)
  end
end
