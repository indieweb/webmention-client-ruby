# frozen_string_literal: true

module Webmention
  module Parsers
    # @api private
    class Html < Base
      @mime_types = ["text/html"]

      # An array of HTML +srcset+ attributes.
      #
      # @see https://html.spec.whatwg.org/#srcset-attributes HTML Standard § 4.8.4.2.1 Srcset attributes
      SRCSET_ATTRIBUTES = ["imagesrcset", "srcset"].freeze

      # A map of HTML URL attributes and their associated element names.
      #
      # @see https://html.spec.whatwg.org/#attributes-3 HTML Standard § Attributes
      #
      # rubocop:disable-next Layout/HashAlignment
      URL_ATTRIBUTES_MAP = {
        "cite"   => ["blockquote", "del", "ins", "q"],
        "data"   => ["object"],
        "href"   => ["a", "area"],
        "poster" => ["video"],
        "src"    => ["audio", "embed", "img", "source", "track", "video"],
        "srcset" => ["img", "source"],
      }.freeze

      # @param document [HTTP::Response::Body, String, #to_s]
      # @param context [String, Array<String>]
      def initialize(document, context: nil)
        @context = context

        super
      end

      # Parse an HTML document for absolute or relative URLs.
      #
      # @return [Array<String>] An array of absolute URLs.
      def parse
        @parse ||=
          context_node
            .xpath(*xpaths_from_url_attributes_map)
            .lazy
            .flat_map { |node| parse_attribute_node(node) }
            .to_a
      end

      private

      # @return [Nokogiri::XML::Element]
      def context_node
        @context_node ||= doc.search(*Array(@context)).first || doc
      end

      # @return [Nokogiri::HTML5::Document]
      def doc
        Nokogiri.HTML5(@document)
      end

      # @return [String, Array<String>]
      def parse_attribute_node(node)
        return node.value.strip unless SRCSET_ATTRIBUTES.include?(node.name)

        node.value.split(/\s*,\s*/).lazy.flat_map { |value| value.strip.split(/\s|$/)[0] }
      end

      # @return [Array<String>]
      def xpaths_from_url_attributes_map
        URL_ATTRIBUTES_MAP.each_with_object([]) do |(attribute, names), xpaths|
          xpaths.concat(names.map { |name| ".//#{name}/@#{attribute}" })
        end
      end
    end
  end
end
