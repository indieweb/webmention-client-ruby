# frozen_string_literal: true

RSpec.describe Webmention::Parsers::HtmlParser, "#results" do
  subject(:results) { described_class.new(response_body, "https://jgarber.example/foo").results }

  context "when response body contains no URLs" do
    let(:response_body) { load_fixture(:sample_post_no_links) }

    it { is_expected.to eq([]) }
  end

  context "when response body contains URLs within an h-entry" do
    let(:response_body) { load_fixture(:sample_post) }

    let(:extracted_urls) do
      [
        "https://aaronpk.example/post/1",
        "https://aaronpk.example/post/2",
        "https://aaronpk.example/post/2",
        "https://jgarber.example",
        "https://aaronpk.example/image.jpg",
        "https://aaronpk.example/image-1x.jpg",
        "https://aaronpk.example/image-2x.jpg"
      ]
    end

    it { is_expected.to eq(extracted_urls) }
  end
end
