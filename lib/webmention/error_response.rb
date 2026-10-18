# frozen_string_literal: true

module Webmention
  class ErrorResponse
    # @return [String]
    attr_reader :message

    # @return [Request]
    attr_reader :request

    # Create a new {ErrorResponse}.
    #
    # Instances of this class represent HTTP requests that generated errors
    # (e.g. connection error, SSL error) or that could not locate a Webmention
    # endpoint. The nature of the error is captured in the {#message} instance
    # method.
    #
    # @api private
    #
    # @param message [String]
    # @param request [Request]
    def initialize(message, request)
      @message = message
      @request = request
    end

    # @return [String]
    def inspect
      "#<#{self.class}:#{format("%#0x", object_id)} " \
        "message: #{message}>"
    end

    # @return [Set]
    def mentioned_urls
      Set.new
    end

    # @return [Boolean]
    def ok?
      false
    end
  end
end
