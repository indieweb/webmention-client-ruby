module Webmention
  class Error < StandardError; end

  class ArgumentError < Error; end

  class ConnectionError < Error; end

  class InvalidURIError < Error; end

  class TimeoutError < Error; end

  class TooManyRedirectsError < Error; end

  class UnsupportedMimeTypeError < Error; end
end
