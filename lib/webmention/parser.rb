module Webmention
  class Parser
    def initialize(response)
      raise ArgumentError, "response must be an HTTP::Response (given #{response.class.name})" unless response.is_a?(HTTP::Response)

      @response = response

      raise UnsupportedMimeTypeError, "Unsupported MIME Type: #{response.mime_type}" unless self.class.mime_types.include?(response.mime_type)
    end

    def results
      @results ||= parse_response_body
    end

    class << self
      def inherited(base)
        subclasses << base

        super(base)
      end

      def mime_types
        mime_types = []

        subclasses.each { |subclass| mime_types << subclass.mime_types }

        mime_types.flatten.sort
      end

      def subclasses
        @subclasses ||= []
      end
    end

    private

    def response_body
      @response_body ||= @response.body.to_s
    end
  end
end
