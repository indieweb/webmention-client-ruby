# frozen_string_literal: true

require 'absolutely'
require 'addressable/uri'
require 'http'
require 'indieweb/endpoints'
require 'nokogiri'

require_relative 'webmention/version'
require_relative 'webmention/exceptions'

require_relative 'webmention/client'

require_relative 'webmention/parsers'
require_relative 'webmention/parsers/base_parser'
require_relative 'webmention/parsers/html_parser'

require_relative 'webmention/services/http_request_service'

module Webmention
  # Create a new Webmention::Client
  # Convenience method for Webmention::Client.new
  #
  #   client = Webmention.client('https://source.example.com/post/100')
  #
  # @param source [String] An absolute URL representing the source document
  # @return [Webmention::Client]
  def self.client(source)
    Client.new(source)
  end

  # Send a webmention from the source URL to the target URL
  #
  # @param source [String] An absolute URL representing the source document
  # @param target [String] An absolute URL representing the target document
  # @return [HTTP::Response, nil]
  def self.send_mention(source, target)
    client(source).send_mention(target)
  end
end
