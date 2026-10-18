# frozen_string_literal: true

require "json"

require "burly"
require "http"
require "indieweb/endpoints"
require "nokogiri"

require_relative "webmention/client"
require_relative "webmention/url"
require_relative "webmention/request"
require_relative "webmention/response"
require_relative "webmention/error_response"
require_relative "webmention/verification"

# Send and verify Webmention notifications.
#
# @see https://indieweb.org/Webmention
module Webmention
  # Retrieve unique URLs mentioned by the provided URL.
  #
  # @example
  #   Webmention.mentioned_urls("https://jgarber.example/posts/100")
  #
  # @param url [String, HTTP::URI, #to_s] An absolute URL.
  #
  # @raise (see Client#mentioned_urls)
  #
  # @return (see Client#mentioned_urls)
  def self.mentioned_urls(url)
    Client.new(url).mentioned_urls
  end

  # Send a webmention from a source URL to a target URL.
  #
  # @example Send a webmention
  #   source = "https://jgarber.example/posts/100"
  #   target = "https://aaronpk.example/notes/1"
  #   Webmention.send_webmention(source, target)
  #
  # @example Send a webmention with a vouch URL
  #   source = "https://jgarber.example/posts/100"
  #   target = "https://aaronpk.example/notes/1"
  #   Webmention.send_webmention(source, target, vouch: "https://tantek.example/notes/1")
  #
  # @see https://indieweb.org/Vouch
  #
  # @param source (see Client#initialize)
  # @param target (see Client#send_webmention)
  # @param vouch (see Client#initialize)
  #
  # @return (see Client#send_webmention)
  def self.send_webmention(source, target, vouch: nil)
    Client.new(source, vouch: vouch).send_webmention(target)
  end

  # Send webmentions from a source URL to multiple target URLs.
  #
  # @example Send multiple webmentions
  #   source = "https://jgarber.example/posts/100"
  #   targets = ["https://aaronpk.example/notes/1", "https://adactio.example/notes/1"]
  #   Webmention.send_webmentions(source, targets)
  #
  # @example Send multiple webmentions with a vouch URL
  #   source = "https://jgarber.example/posts/100"
  #   targets = ["https://aaronpk.example/notes/1", "https://adactio.example/notes/1"]
  #   Webmention.send_webmentions(source, targets, vouch: "https://tantek.example/notes/1")
  #
  # @see https://indieweb.org/Vouch
  #
  # @param (see .send_webmention)
  #
  # @return [Array<Response, ErrorResponse>]
  def self.send_webmentions(source, *targets, vouch: nil)
    Client.new(source, vouch: vouch).send_webmentions(*targets)
  end

  # Verify that a source URL links to a target URL.
  #
  # @param (see .send_webmention)
  #
  # @raise (see Client#mentioned_urls)
  #
  # @return [Boolean]
  def self.verify_webmention(source, target, vouch: nil)
    Client.new(source, vouch: vouch).verify_webmention(target)
  end
end
