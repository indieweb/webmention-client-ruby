module Webmention
  module Services
    module NodeParserService
      # Search a node for matching elements
      #
      # @param node [Nokogiri::XML::Element]
      # @param selectors [Array]
      # @return [Nokogiri::XML::NodeSet]
      def self.nodes_from(node, selectors)
        node.css(*selectors)
      end

      # Derive attribute values from a single node
      #
      # @param node [Nokogiri::XML::Element]
      # @param attribute [Symbol]
      # @return [Array] the HTML attribute values
      def self.values_from(node, attribute)
        return Array(node[attribute]) unless attribute == :srcset

        node[attribute].split(',').map { |value| value.strip.match(/^\S+/).to_s }
      end
    end
  end
end
