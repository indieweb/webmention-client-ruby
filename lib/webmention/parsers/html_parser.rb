# frozen_string_literal: true

module Webmention
  module Parsers
    # @api private
    class HtmlParser < Parser
      @mime_types = ["text/html"]

      Client.register_parser(self)

      HTML_ATTRIBUTES_MAP = {
        "cite" => ["blockquote", "del", "ins", "q"],
        "data" => ["object"],
        "href" => ["a", "area"],
        "poster" => ["video"],
        "src" => ["audio", "embed", "img", "source", "track", "video"],
        "srcset" => ["img", "source"],
      }.freeze

      CSS_SELECTORS_ARRAY = HTML_ATTRIBUTES_MAP
                              .flat_map { |attribute, names| names.map { |name| "#{name}[#{attribute}]" } }.freeze

      ROOT_NODE_SELECTORS_ARRAY = [".h-entry .e-content", ".h-entry", "body"].freeze

      private_constant :HTML_ATTRIBUTES_MAP
      private_constant :CSS_SELECTORS_ARRAY
      private_constant :ROOT_NODE_SELECTORS_ARRAY

      # @return [Array<String>] An array of absolute URLs.
      def results
        @results ||=
          extract_urls_from(*url_attributes)
            .map { |url| response_uri.join(url).to_s }
            .grep(Parser::URI_REGEXP)
      end

      private

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
        doc.at_css(*ROOT_NODE_SELECTORS_ARRAY)
      end

      # @return [Array<Nokogiri::XML::Attr>]
      def url_attributes
        url_nodes.flat_map(&:attribute_nodes).select { |attribute| HTML_ATTRIBUTES_MAP.key?(attribute.name) }
      end

      # @return [Nokogiri::XML::NodeSet]
      def url_nodes
        root_node.css(*CSS_SELECTORS_ARRAY)
      end
    end
  end
end
