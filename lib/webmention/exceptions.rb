# frozen_string_literal: true

module Webmention
  class WebmentionClientError < StandardError; end

  class ArgumentError < WebmentionClientError; end

  class ConnectionError < WebmentionClientError; end

  class InvalidURIError < WebmentionClientError; end

  class TimeoutError < WebmentionClientError; end

  class TooManyRedirectsError < WebmentionClientError; end

  class UnsupportedMimeTypeError < WebmentionClientError; end
end
