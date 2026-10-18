# frozen_string_literal: true

module Webmention
  class Response
    extend Forwardable

    PARSE_CONTEXT = [".h-entry .e-content", ".h-entry", "body"].freeze
    URI_REGEXP = URI::RFC2396_Parser.new.make_regexp(["http", "https"]).freeze

    private_constant :PARSE_CONTEXT
    private_constant :URI_REGEXP

    # @return [Request]
    attr_reader :request

    # @!method
    #   @return [HTTP::Headers]
    def_delegator :@response, :headers

    # @!method
    #   @return [HTTP::Response::Body]
    def_delegator :@response, :body

    # @!method
    #   @return [Integer]
    def_delegator :@response, :code

    # @!method
    #   @return [String]
    def_delegator :@response, :reason

    # !@method
    #   @return [String]
    def_delegator :@response, :mime_type

    # !@method
    #   @return [HTTP::URI]
    def_delegator :@response, :uri

    # Create a new {Response}.
    #
    # Instances of this class represent completed HTTP requests, the details
    # of which may be accessed using the delegated {#code} and {#reason}
    # instance methods.
    #
    # @api private
    #
    # @param response [HTTP::Response]
    # @param request [Request]
    def initialize(response, request)
      @response = response
      @request = request
    end

    # @return [String]
    #
    # simplecov:disable
    def inspect
      "#<#{self.class}:#{format("%#0x", object_id)} " \
        "code: #{code.inspect}, " \
        "reason: #{reason}, " \
        "url: #{request.uri}>"
    end
    # simplecov:enable

    # Parse the response body for unique host names.
    #
    # @return [Set<String>]
    def mentioned_hosts
      @mentioned_hosts ||= Set.new(mentioned_urls.map { |url| HTTP::URI.parse(url).host })
    end

    # Parse the response body for mentioned URLs.
    #
    # @return [Set<String>]
    def mentioned_urls
      @mentioned_urls ||=
        Set.new(
          Burly
            .parse(@response.body, context: PARSE_CONTEXT, mime_type: @response.mime_type)
            .map { |url| @response.uri.join(url).to_s }
            .grep(URI_REGEXP)
        )
    end

    # @return [Boolean]
    def ok?
      true
    end
  end
end
