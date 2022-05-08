# frozen_string_literal: true

require 'http'
require 'indieweb/endpoints'
require 'nokogiri'

require_relative 'webmention/version'

require_relative 'webmention/client'
require_relative 'webmention/target_url'
require_relative 'webmention/request'
require_relative 'webmention/response'
require_relative 'webmention/error_response'

module Webmention
end
