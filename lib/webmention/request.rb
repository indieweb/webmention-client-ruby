module Webmention
  class Request
    HTTP_HEADERS_OPTS = {
      accept: '*/*',
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
    rescue HTTP::ConnectionError => error
      raise ConnectionError, error
    rescue HTTP::TimeoutError => error
      raise TimeoutError, error
    rescue HTTP::Redirector::TooManyRedirectsError => error
      raise TooManyRedirectsError, error
    end
  end
end
