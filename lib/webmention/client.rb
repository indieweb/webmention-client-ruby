require 'logger'
module Webmention
  class Client
    def initialize(source, logger: Logger.new(STDOUT))
      raise ArgumentError, "source must be a String (given #{source.class.name})" unless source.is_a?(String)

      @source = source
      @logger = logger

      raise ArgumentError, 'source must be an absolute URL (e.g. https://example.com)' unless source_uri.absolute?
    end

    def send_all_mentions
      mentioned_urls.each_with_object({}) { |url, hash| hash[url] = send_mention(url) }
    end

    def mentioned_urls
      raise UnsupportedMimeTypeError, "Unsupported MIME Type: #{source_response.mime_type}" unless parser_for_mime_type

      @mentioned_urls ||= parser_for_mime_type.new(source_response).results
    end

    def send_mention(target)
      @logger.debug(%(Attempting to send mention from "#{@source}" to "#{target}"))
      endpoint = IndieWeb::Endpoints.get(target).webmention

      if endpoint
        @logger.debug(%(\tusing endpoint "#{endpoint}"))
        Services::HttpRequestService.post(Addressable::URI.parse(endpoint), source: @source, target: target)
      else
        @logger.debug(%(\tbut could not find webmention endpoint))
      end
    rescue IndieWeb::Endpoints::IndieWebEndpointsError => exception
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
