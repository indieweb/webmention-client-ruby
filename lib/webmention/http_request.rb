module Webmention
  class HttpRequest
    HTTP_HEADERS_OPTS = {
      accept:     '*/*',
      user_agent: 'Webmention Client (https://rubygems.org/gems/webmention)'
    }.freeze

    class << self
      def get(uri)
        request(:get, uri)
      end

      def post(uri, **options)
        request(:post, uri, form: options)
      end

      private

      def request(method, uri, **options)
        raise ArgumentError, "uri must be an Addressable::URI (given #{uri.class.name})" unless uri.is_a?(Addressable::URI)

        HTTP.follow.headers(HTTP_HEADERS_OPTS).timeout(connect: 10, read: 10).request(method, uri, options)
      rescue HTTP::ConnectionError,
             HTTP::TimeoutError,
             HTTP::Redirector::TooManyRedirectsError => exception
        raise Webmention.const_get(exception.class.name.split('::').last), exception
      end
    end
  end
end
