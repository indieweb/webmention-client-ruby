# frozen_string_literal: true

module Webmention
  module Parsers
    class HtmlParser < BaseParser
      @mime_types = ['text/html']

      Parsers.register(self)

      HTML_ATTRIBUTES_MAP = {
        'cite'   => %w[blockquote del ins q],
        'data'   => %w[object],
        'href'   => %w[a area],
        'poster' => %w[video],
        'src'    => %w[audio embed img source track video],
        'srcset' => %w[img source]
      }.freeze

      CSS_SELECTORS_ARRAY = HTML_ATTRIBUTES_MAP.flat_map { |attribute, names| names.map { |name| "#{name}[#{attribute}]" } }.freeze

      # Parse an HTML string for URLs
      #
      # @return [Array<String>] Unique external URLs whose scheme matches http/https
      def results
        @results ||= resolved_urls.uniq.select { |url| url.match?(%r{https?://}) }.reject { |url| url.match(/^#{response_url}(?:#.*)?$/) }
      end

      private

      def doc
        @doc ||= Nokogiri::HTML(response_body)
      end

      def resolved_urls
        UrlAttributesParser.parse(*url_attributes).map { |url| Absolutely.to_abs(base: response_url, relative: url) }
      end

      def root_node
        doc.at_css('.h-entry .e-content', '.h-entry') || doc.css('body')
      end

      def url_attributes
        url_nodes.flat_map(&:attribute_nodes).select { |attribute| HTML_ATTRIBUTES_MAP.key?(attribute.name) }
      end

      def url_nodes
        root_node.css(*CSS_SELECTORS_ARRAY)
      end

      module UrlAttributesParser
        # @param attributes [Array<Nokogiri::XML::Attr>]
        # @return [Array<String>]
        def self.parse(*attributes)
          attributes.flat_map { |attribute| value_from(attribute) }
        end

        # @param attribute [Nokogiri::XML::Attr]
        # @return [String, Array<String>]
        def self.value_from(attribute)
          return attribute.value unless attribute.name == 'srcset'

          attribute.value.split(',').map { |value| value.strip.match(/^\S+/).to_s }
        end
      end
    end
  end
end
