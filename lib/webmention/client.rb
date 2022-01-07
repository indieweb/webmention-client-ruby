# frozen_string_literal: true

module Webmention
  class Client
    # Create a new Webmention::Client
    #
    #   client = Webmention::Client.new('https://source.example.com/post/100')
    #
    # @param source [String] An absolute URL representing the source document
    def initialize(source)
      raise ArgumentError, "source must be a String (given #{source.class.name})" unless source.is_a?(String)

      @source = source

      raise ArgumentError, 'source must be an absolute URL (e.g. https://example.com)' unless source_uri.absolute?
    end

    # Send webmentions to all mentioned URLs in this client's source document
    #
    # @return [Hash{String => HTTP::Response, nil}]
    def send_all_mentions
      mentioned_urls.each_with_object({}) { |url, hash| hash[url] = send_mention(url) }
    end

    # Extract mentioned URLs from this client's source document
    #
    # @return [Array<String>]
    # @raise [Webmention::UnsupportedMimeTypeError]
    def mentioned_urls
      raise UnsupportedMimeTypeError, "Unsupported MIME Type: #{source_response.mime_type}" unless parser_for_mime_type

      @mentioned_urls ||= parser_for_mime_type.new(source_response).results
    end

    # Send a webmention from this client's source URL to the target URL
    #
    # @param target [String] An absolute URL representing the target document
    # @return [HTTP::Response, nil]
    # @raise [Webmention::ArgumentError, Webmention::ConnectionError, Webmention::InvalidURIError, Webmention::TimeoutError, Webmention::TooManyRedirectsError]
    def send_mention(target)
      endpoint = IndieWeb::Endpoints.get(target)[:webmention]

      return unless endpoint

      Services::HttpRequestService.post(Addressable::URI.parse(endpoint), source: @source, target: target)
    rescue IndieWeb::Endpoints::Error => exception
      raise Webmention.const_get(exception.class.name.split('::').last), exception
    end

    private

    def parser_for_mime_type
      @parser_for_mime_type ||= Parsers.registered[source_response.mime_type]
    end

    def source_response
      @source_response ||= Services::HttpRequestService.get(source_uri)
    end

    def source_uri
      @source_uri ||= Addressable::URI.parse(@source)
    rescue Addressable::URI::InvalidURIError => exception
      raise InvalidURIError, exception
    end
  end
end
