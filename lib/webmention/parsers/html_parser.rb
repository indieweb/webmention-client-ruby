# frozen_string_literal: true

module Webmention
  module Parsers
    class HtmlParser < Parser
      @mime_types = ['text/html']

      Client.register_parser(self)

      HTML_ATTRIBUTES_MAP = {
        'cite'   => %w[blockquote del ins q],
        'data'   => %w[object],
        'href'   => %w[a area],
        'poster' => %w[video],
        'src'    => %w[audio embed img source track video],
        'srcset' => %w[img source]
      }.freeze

      CSS_SELECTORS_ARRAY = HTML_ATTRIBUTES_MAP.flat_map do |attribute, names|
        names.map { |name| "#{name}[#{attribute}]" }
      end.freeze

      ROOT_NODE_SELECTORS_ARRAY = ['.h-entry .e-content', '.h-entry', 'body'].freeze

      private_constant :HTML_ATTRIBUTES_MAP
      private_constant :CSS_SELECTORS_ARRAY
      private_constant :ROOT_NODE_SELECTORS_ARRAY

      # @return [Array<String>] An array of absolute URLs.
      def results
        @results ||=
          UrlExtractor.extract(*url_attributes)
                      .map { |url| response_uri.join(url).to_s }
                      .grep(Parser::URI_REGEXP)
      end

      private

      # @return [Nokogiri::HTML5::Document]
      def doc
        Nokogiri.HTML5(response_body)
      end

      # @return [Nokogiri::XML::Element]
      def root_node
        doc.at_css(*ROOT_NODE_SELECTORS_ARRAY)
      end

      # @return [Array<Nokogiri::XML::Attr>]
      def url_attributes
        url_nodes.flat_map(&:attribute_nodes).find_all { |attribute| HTML_ATTRIBUTES_MAP.key?(attribute.name) }
      end

      # @return [Nokogiri::XML::NodeSet]
      def url_nodes
        root_node.css(*CSS_SELECTORS_ARRAY)
      end

      module UrlExtractor
        # @param attributes [Array<Nokogiri::XML::Attr>]
        #
        # @return [Array<String>]
        def self.extract(*attributes)
          attributes.flat_map { |attribute| values_from(attribute) }
        end

        # @param attribute [Nokogiri::XML::Attr]
        #
        # @return [String, Array<String>]
        def self.values_from(attribute)
          return attribute.value unless attribute.name == 'srcset'

          attribute.value.split(',').map { |value| value.strip.match(/^\S+/).to_s }
        end
      end
    end
  end
end
