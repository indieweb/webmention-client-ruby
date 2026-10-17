# frozen_string_literal: true

module Webmention
  module Parsers
    # @api private
    class Html < Base
      @mime_types = ["text/html"]

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

      private_constant :URL_ATTRIBUTES_MAP

      # @return [Array<String>] An array of absolute URLs.
      def parse
        @parse ||=
          extract_urls_from(*url_attributes)
            .map { |url| response_uri.join(url).to_s }
            .grep(uri_regexp)
      end

      private

      def css_selectors_from_url_attributes_map
        URL_ATTRIBUTES_MAP.each_with_object([]) do |(attribute, names), css_selectors|
          css_selectors.concat(names.map { |name| "#{name}[#{attribute}]" })
        end
      end

      # @return [Nokogiri::HTML5::Document]
      def doc
        Nokogiri.HTML5(response_body)
      end

      # @param attributes [Array<Nokogiri::XML::Attr>]
      #
      # @return [Array<String>]
      def extract_urls_from(*attributes)
        attributes.flat_map do |attribute|
          if attribute.name == "srcset"
            attribute.value.split(",").map { |value| value.strip.match(/^\S+/).to_s }
          else
            attribute.value
          end
        end
      end

      # @return [Nokogiri::XML::Element]
      def root_node
        doc.at_css(".h-entry .e-content", ".h-entry", "body")
      end

      # @return [Array<Nokogiri::XML::Attr>]
      def url_attributes
        url_nodes.flat_map(&:attribute_nodes).select { |attribute| URL_ATTRIBUTES_MAP.key?(attribute.name) }
      end

      # @return [Nokogiri::XML::NodeSet]
      def url_nodes
        root_node.css(*css_selectors_from_url_attributes_map)
      end
    end
  end
end
