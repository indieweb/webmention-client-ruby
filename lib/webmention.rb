# frozen_string_literal: true

require 'json'

require 'http'
require 'indieweb/endpoints'
require 'nokogiri'

require_relative 'webmention/version'

require_relative 'webmention/client'
require_relative 'webmention/target_url'
require_relative 'webmention/request'
require_relative 'webmention/response'
require_relative 'webmention/error_response'

require_relative 'webmention/parser'
require_relative 'webmention/parsers/html_parser'
require_relative 'webmention/parsers/json_parser'
require_relative 'webmention/parsers/plaintext_parser'

module Webmention
end
