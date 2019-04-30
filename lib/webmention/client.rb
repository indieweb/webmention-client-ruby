module Webmention
  class Client
    def initialize(url)
      raise ArgumentError, "url must be a String (given #{url.class.name})" unless url.is_a?(String)

      @url = url
      @uri = Addressable::URI.parse(url)

      raise ArgumentError, 'url must be an absolute URI (e.g. https://example.com)' unless @uri.absolute?
    rescue Addressable::URI::InvalidURIError => exception
      raise InvalidURIError, exception
    end

    def mentioned_urls
      raise UnsupportedMimeTypeError, "Unsupported MIME Type: #{response.mime_type}" unless parser_for_mime_type

      @mentioned_urls ||= parser_for_mime_type.new(response).results
    end

    def send_all_mentions
      mentioned_urls.map do |url|
        {
          url:      url,
          response: send_mention(url)
        }
      end
    end

    def send_mention(url)
      endpoint = IndieWeb::Endpoints.get(url).webmention

      return unless endpoint

      PostRequest.new(Addressable::URI.parse(endpoint), source: @url, target: url).response
    rescue IndieWeb::Endpoints::Error => exception
      raise Webmention.const_get(exception.class.name.split('::').last), exception
    end

    private

    def parser_for_mime_type
      @parser_for_mime_type ||= Parser.subclasses.find { |parser| parser.mime_types.include?(response.mime_type) }
    end

    def response
      @response ||= GetRequest.new(@uri).response
    end
  end
end
