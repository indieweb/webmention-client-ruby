module Webmention
  class Request
    HTTP_HEADERS_OPTS = {
      accept:     '*/*',
      user_agent: 'Webmention Client (https://rubygems.org/gems/webmention)'
    }.freeze

    def initialize(uri, params = nil)
      raise ArgumentError, "uri must be an Addressable::URI (given #{uri.class.name})" unless uri.is_a?(Addressable::URI)

      @uri = uri
      @params = params

      raise ArgumentError, "params must be an Enumerable (given #{params.class.name})" if params && !params.is_a?(Enumerable)
    end

    def response
      @response ||= perform_request
    rescue HTTP::ConnectionError => exception
      raise ConnectionError, exception
    rescue HTTP::TimeoutError => exception
      raise TimeoutError, exception
    rescue HTTP::Redirector::TooManyRedirectsError => exception
      raise TooManyRedirectsError, exception
    end
  end
end
