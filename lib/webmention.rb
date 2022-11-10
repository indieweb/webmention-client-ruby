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
require_relative 'webmention/verification'

require_relative 'webmention/parser'
require_relative 'webmention/parsers/html_parser'
require_relative 'webmention/parsers/json_parser'
require_relative 'webmention/parsers/plaintext_parser'

module Webmention
  # Retrieve unique URLs mentioned by the provided URL.
  #
  # @example
  #   Webmention.mentioned_urls('https://jgarber.example/posts/100')
  #
  # @param url [String, HTTP::URI, #to_s] An absolute URL.
  #
  # @raise [NoMethodError]
  #   Raised when response is a Webmention::ErrorResponse or response is of an
  #   unsupported MIME type.
  #
  # @return [Array<String>]
  def self.mentioned_urls(url)
    Client.new(url).mentioned_urls
  end

  # Send a webmention from a source URL to a target URL.
  #
  # @example Send a webmention
  #   source = 'https://jgarber.example/posts/100'
  #   target = 'https://aaronpk.example/notes/1'
  #   Webmention.send_webmention(source, target)
  #
  # @example Send a webmention with a vouch URL
  #   source = 'https://jgarber.example/posts/100'
  #   target = 'https://aaronpk.example/notes/1'
  #   Webmention.send_webmention(source, target, vouch: 'https://tantek.example/notes/1')
  #
  # @param source [String, HTTP::URI, #to_s]
  #   An absolute URL representing a source document.
  # @param target [String, HTTP::URI, #to_s]
  #   An absolute URL representing a target document.
  # @param vouch [String, HTTP::URI, #to_s]
  #   An absolute URL representing a document vouching for the source document.
  #   See https://indieweb.org/Vouch for additional details.
  #
  # @return [Webmention::Response, Webmention::ErrorResponse]
  def self.send_webmention(source, target, vouch: nil)
    Client.new(source, vouch: vouch).send_webmention(target)
  end

  # Send webmentions from a source URL to multiple target URLs.
  #
  # @example Send multiple webmentions
  #   source = 'https://jgarber.example/posts/100'
  #   targets = ['https://aaronpk.example/notes/1', 'https://adactio.example/notes/1']
  #   Webmention.send_webmentions(source, targets)
  #
  # @example Send multiple webmentions with a vouch URL
  #   source = 'https://jgarber.example/posts/100'
  #   targets = ['https://aaronpk.example/notes/1', 'https://adactio.example/notes/1']
  #   Webmention.send_webmentions(source, targets, vouch: 'https://tantek.example/notes/1')
  #
  # @param source [String, HTTP::URI, #to_s]
  #   An absolute URL representing a source document.
  # @param targets [Array<String, HTTP::URI, #to_s>]
  #   An array of absolute URLs representing multiple target documents.
  # @param vouch [String, HTTP::URI, #to_s]
  #   An absolute URL representing a document vouching for the source document.
  #   See https://indieweb.org/Vouch for additional details.
  #
  # @return [Array<Webmention::Response, Webmention::ErrorResponse>]
  def self.send_webmentions(source, *targets, vouch: nil)
    Client.new(source, vouch: vouch).send_webmentions(*targets)
  end

  # Verify that a source URL links to a target URL.
  #
  # @param (see Webmention.send_webmention)
  #
  # @raise (see Webmention::Client#mentioned_urls)
  #
  # @return [Boolean]
  def self.verify_webmention(source, target, vouch: nil)
    Client.new(source, vouch: vouch).verify_webmention(target)
  end
end
