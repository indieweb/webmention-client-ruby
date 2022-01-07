# frozen_string_literal: true

module Webmention
  module Services
    module HttpRequestService
      # Defaults derived from Webmention specification examples
      # https://www.w3.org/TR/webmention/#limits-on-get-requests
      HTTP_CLIENT_OPTS = {
        follow: {
          max_hops: 20
        },
        headers: {
          accept: '*/*',
          user_agent: 'Webmention Client (https://rubygems.org/gems/webmention)'
        },
        timeout_options: {
          connect_timeout: 5,
          read_timeout: 5
        }
      }.freeze

      class << self
        def get(uri)
          request(:get, uri)
        end

        def post(uri, **options)
          request(:post, uri, form: options)
        end

        private

        def client
          @client ||= HTTP::Client.new(HTTP_CLIENT_OPTS)
        end

        def request(method, uri, **options)
          client.request(method, uri, options)
        rescue HTTP::ConnectionError,
               HTTP::TimeoutError,
               HTTP::Redirector::TooManyRedirectsError => exception
          raise Webmention.const_get(exception.class.name.split('::').last), exception
        end
      end
    end
  end
end
