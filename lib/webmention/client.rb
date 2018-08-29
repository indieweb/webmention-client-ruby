module Webmention
  class Client
    def initialize(url)
      raise ArgumentError, "url must be a String (given #{url.class.name})" unless url.is_a?(String)

      @url = url
      @uri = Addressable::URI.parse(url)

      raise ArgumentError, 'url must be an absolute URI (e.g. https://example.com)' unless @uri.absolute?
    rescue Addressable::URI::InvalidURIError => error
      raise InvalidURIError, error
    end

    def mentioned_urls
      raise UnsupportedMimeTypeError, "Unsupported MIME Type: #{response.mime_type}" unless parser_for_mime_type

      @mentioned_urls ||= parser_for_mime_type.new(response).results
    end

    # def send(url)
    # end

    # def send_all
    # end

    private

    def parser_for_mime_type
      @parser_for_mime_type ||= Parser.subclasses.find { |parser| parser.mime_types.include?(response.mime_type) }
    end

    def response
      @response ||= GetRequest.new(@uri).response
    end
  end
end
