module Webmention
  class HtmlParser < Parser
    # rubocop:disable Layout/AlignHash
    HTML_ATTRIBUTE_MAPPINGS = {
      cite:   %w[blockquote del ins q],
      data:   %w[object],
      href:   %w[a area],
      poster: %w[video],
      src:    %w[audio embed img source track video],
      srcset: %w[img source]
    }.freeze
    # rubocop:enable Layout/AlignHash

    def self.mime_types
      ['text/html']
    end

    private

    def doc
      @doc ||= Nokogiri::HTML(response_body)
    end

    def parse_node(node, attribute)
      value = node[attribute]

      return value unless attribute == :srcset

      value.split(',').map { |link| link.strip.split(' ').first }
    end

    def parse_response_body
      matches = Set.new

      HTML_ATTRIBUTE_MAPPINGS.each do |attribute, elements|
        elements.each do |element|
          matches.merge(search_doc(element, attribute).map { |match| Absolutely.to_absolute_uri(base: response_url, relative: match) })
        end
      end

      matches.to_a
    end

    def response_url
      @response_url ||= @response.uri.to_s
    end

    def search_doc(element, attribute)
      doc.css("#{element}[#{attribute}]").map { |node| parse_node(node, attribute) }.flatten
    end
  end
end
