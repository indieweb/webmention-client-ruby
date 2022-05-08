# frozen_string_literal: true

module Webmention
  class Response
    extend Forwardable

    # @return [Webmention::Request]
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

    # Create a new Webmention::Response.
    #
    # Instances of this class represent completed HTTP requests, the details
    # of which may be accessed using the delegated <code>#code</code> and
    # <code>#reason</code>) instance methods.
    #
    # @param response [HTTP::Response]
    # @param request [Webmention::Request]
    #
    # @return [Webmention::Response]
    def initialize(response, request)
      @response = response
      @request = request
    end

    # :nocov:
    # @return [String]
    def inspect
      "#<#{self.class}:#{format('%#0x', object_id)} " \
        "code: #{code.inspect}, " \
        "reason: #{reason}, " \
        "url: #{request.uri}>"
    end
    # :nocov:

    # @return [Boolean]
    def ok?
      true
    end
  end
end
