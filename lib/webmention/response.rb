# frozen_string_literal: true

module Webmention
  # An interface to instances of the {Request} and `HTTP::Response` classes.
  #
  # A {Response} represents the results of a successful {Request}.
  class Response
    extend Forwardable

    # Consider the first h-entry to be the authoritative content container when
    # parsing a document for mentioned URLs. Fall back to the `<body>` element
    # when no h-entry is found.
    #
    # @see http://microformats.org/wiki/h-entry
    PARSE_CONTEXT = [".h-entry .e-content", ".h-entry", "body"].freeze

    URI_REGEXP = URI::RFC2396_Parser.new.make_regexp(["http", "https"]).freeze

    public_constant :PARSE_CONTEXT
    private_constant :URI_REGEXP

    # The {Request} associated with this {Response}.
    #
    # @return [Request]
    attr_reader :request

    # @!method headers
    #   @return [HTTP::Headers]
    def_delegator :@response, :headers

    # @!method body
    #   @return [HTTP::Response::Body]
    def_delegator :@response, :body

    # @!method code
    #   @return [Integer]
    def_delegator :@response, :code

    # @!method reason
    #   @return [String]
    def_delegator :@response, :reason

    # @!method mime_type
    #   @return [String]
    def_delegator :@response, :mime_type

    # @!method uri
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

    # @!visibility private
    # simplecov:disable
    def inspect
      "#<#{self.class}:#{format("%#0x", object_id)} " \
        "code: #{code.inspect}, " \
        "reason: #{reason}, " \
        "url: #{request.uri}>"
    end
    # simplecov:enable

    # Unique host names parsed from the response body.
    #
    # The returned `Set` contains the unique host names ("domain names") derived
    # from the `Set` of {mentioned_urls}. Order is not guaranteed.
    #
    # @return [Set<String>]
    def mentioned_hosts
      @mentioned_hosts ||= Set.new(mentioned_urls.map { |url| HTTP::URI.parse(url).host })
    end

    # Unique mentioned URLs parsed from the response body.
    #
    # The returned `Set` contains the unique URLs parsed from the
    # {PARSE_CONTEXT}. Order is not guaranteed.
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

    # A {Response} is always okay!
    #
    # @return [true]
    def ok?
      true
    end
  end
end
