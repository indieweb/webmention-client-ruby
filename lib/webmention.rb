# frozen_string_literal: true

require 'json'

require 'http'
require 'indieweb/endpoints'
require 'nokogiri'

require_relative 'webmention/version'

require_relative 'webmention/client'
require_relative 'webmention/url'
require_relative 'webmention/request'
require_relative 'webmention/response'
require_relative 'webmention/error_response'

require_relative 'webmention/parser'
require_relative 'webmention/parsers/html_parser'
require_relative 'webmention/parsers/json_parser'
require_relative 'webmention/parsers/plaintext_parser'

module Webmention
  # Retrieve unique URLs mentioned by the source URL.
  #
  # @example
  #   Webmention.mentioned_urls('https://jgarber.example/posts/100')
  #
  # @param source [String, HTTP::URI, #to_s]
  #   An absolute URL representing the source document.
  #
  # @raise [NoMethodError] Occurs when response is a Webmention::ErrorResponse.
  # @raise [KeyError] Occurs when response if of an unsupported MIME type.
  #
  # @return [Array<String>]
  def self.mentioned_urls(source)
    Client.new(source).mentioned_urls
  end

  # Send a webmention from tthe source URL to the target URL.
  #
  # @example
  #   source = 'https://jgarber.example/posts/100'
  #   target = 'https://aaronpk.example/notes/1'
  #   Webmention.send_webmention(source, target)
  #
  # @param source [String, HTTP::URI, #to_s]
  #   An absolute URL representing the source document.
  # @param target [String, HTTP::URI, #to_s]
  #   An absolute URL representing the target document.
  #
  # @return [Webmention::Response, Webmention::ErrorResponse]
  def self.send_webmention(source, target)
    Client.new(source).send_webmention(target)
  end

  # Send webmentions from the source URL to the target URLs.
  #
  # @example
  #   source = 'https://jgarber.example/posts/100'
  #   targets = ['https://aaronpk.example/notes/1', 'https://adactio.example/notes/1']
  #   Webmention.send_webmentions(source, targets)
  #
  # @param source [String, HTTP::URI, #to_s]
  #   An absolute URL representing the source document.
  # @param *targets [Array<String, HTTP::URI, #to_s>]
  #   An array of absolute URLs representing the target documents.
  #
  # @return [Array<Webmention::Response, Webmention::ErrorResponse>]
  def self.send_webmentions(source, *targets)
    Client.new(source).send_webmentions(*targets)
  end
end
