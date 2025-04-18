# frozen_string_literal: true

module Webmention
  class Verification
    # Create a new {Verification}.
    #
    # @param source_url [Url]
    #   An {URL} representing a source document.
    # @param target_url [Url]
    #   An {URL} representing a target document.
    # @param vouch_url [Url]
    #   An {URL} representing a document vouching for the source document.
    #   See https://indieweb.org/Vouch for additional details.
    def initialize(source_url, target_url, vouch_url: nil)
      @source_url = source_url
      @target_url = target_url
      @vouch_url = vouch_url
    end

    # :nocov:
    # @return [String]
    def inspect
      "#<#{self.class}:#{format("%#0x", object_id)} " \
        "source_url: #{source_url} " \
        "target_url: #{target_url} " \
        "vouch_url: #{vouch_url}>"
    end
    # :nocov:

    # @return [Boolean]
    def source_mentions_target?
      @source_mentions_target ||= mentioned_urls(source_url.response).any?(target_url.to_s)
    end

    # @return [Boolean]
    def verified?
      return source_mentions_target? unless verify_vouch?

      source_mentions_target? && vouch_mentions_source?
    end

    # @return [Boolean]
    def verify_vouch?
      !vouch_url.nil? && !vouch_url.to_s.strip.empty?
    end

    # @return [Boolean]
    def vouch_mentions_source?
      @vouch_mentions_source ||=
        verify_vouch? && mentioned_domains(vouch_url.response).any?(source_url.uri.host)
    end

    private

    # @return [Url]
    attr_reader :source_url

    # @return [Url]
    attr_reader :target_url

    # @return [Url]
    attr_reader :vouch_url

    # @param response [Response]
    #
    # @raise (see Client#mentioned_urls)
    #
    # @return [Array<String>]
    def mentioned_domains(response)
      Set.new(mentioned_urls(response).map { |url| HTTP::URI.parse(url).host }).to_a
    end

    # @param response [Response]
    #
    # @raise (see Client#mentioned_urls)
    #
    # @return [Array<String>]
    def mentioned_urls(response)
      Set.new(
        Client.registered_parsers[response.mime_type]
              .new(response.body, response.uri)
              .results
      ).to_a
    end
  end
end
