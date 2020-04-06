module Webmention
  module Parsers
    class HtmlParser < BaseParser
      @mime_types = ['text/html']

      Parsers.register(self)

      HTML_ATTRIBUTE_MAP = {
        cite:   %w[blockquote del ins q],
        data:   %w[object],
        href:   %w[a area],
        poster: %w[video],
        src:    %w[audio embed img source track video],
        srcset: %w[img source]
      }.freeze

      CSS_SELECTORS_MAP = HTML_ATTRIBUTE_MAP.each_with_object({}) do |(attribute, elements), hash|
        hash[attribute] = elements.map { |element| "#{element}[#{attribute}]" }
      end

      private

      def doc
        @doc ||= Nokogiri::HTML(response_body)
      end

      # Parse an HTML string for URLs
      #
      # @return [Array] the URLs
      def parse_response_body
        CSS_SELECTORS_MAP
          .each_with_object([]) { |(*args), array| array << search_node(*args) }
          .flatten
          .map { |url| Absolutely.to_abs(base: response_url, relative: url) }
          .uniq
      end

      def root_node
        @root_node ||= doc.css('.h-entry .e-content').first || doc.css('.h-entry').first || doc.css('body')
      end

      def search_node(attribute, selectors)
        NodeParser.nodes_from(root_node, selectors).map { |node| NodeParser.values_from(node, attribute) }.reject(&:empty?)
      end

      module NodeParser
        class << self
          # Search a node for matching elements
          #
          # @param node [Nokogiri::XML::Element]
          # @param selectors [Array]
          # @return [Nokogiri::XML::NodeSet]
          def nodes_from(node, selectors)
            node.css(*selectors)
          end

          # Derive attribute values from a single node
          #
          # @param node [Nokogiri::XML::Element]
          # @param attribute [Symbol]
          # @return [Array] the HTML attribute values
          def values_from(node, attribute)
            return Array(node[attribute]) unless attribute == :srcset

            node[attribute].split(',').map { |value| value.strip.match(/^\S+/).to_s }
          end
        end
      end
    end
  end
end
