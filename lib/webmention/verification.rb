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

    # @return [String]
    def inspect
      "#<#{self.class}:#{format("%#0x", object_id)} " \
        "source_url: #{@source_url} " \
        "target_url: #{@target_url} " \
        "vouch_url: #{@vouch_url}>"
    end

    # @return [Boolean]
    def source_mentions_target?
      @source_mentions_target ||= @source_url.response.mentioned_urls.any?(@target_url.to_s)
    end

    # @return [Boolean]
    def verified?
      return source_mentions_target? && vouch_mentions_source? if verify_vouch?

      source_mentions_target?
    end

    # @return [Boolean]
    def verify_vouch?
      !@vouch_url.to_s.strip.empty?
    end

    # @return [Boolean]
    def vouch_mentions_source?
      @vouch_mentions_source ||= verify_vouch? && @vouch_url.response.mentioned_hosts.any?(@source_url.uri.host)
    end
  end
end
