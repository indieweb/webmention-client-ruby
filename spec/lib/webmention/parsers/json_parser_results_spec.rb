# frozen_string_literal: true

RSpec.describe Webmention::Parsers::JsonParser, "#results" do
  subject(:results) { described_class.new(response_body, "https://jgarber.example/foo").results }

  context "when response body contains no URLs" do
    let(:response_body) { load_fixture(:sample_post_no_links, "json") }

    it { is_expected.to eq([]) }
  end

  context "when response body contains URLs" do
    let(:response_body) { load_fixture(:sample_post, "json") }

    let(:extracted_urls) do
      [
        "https://target.example/post/100",
        "https://target.example/post/200",
        "https://target.example/post/100",
      ]
    end

    it { is_expected.to eq(extracted_urls) }
  end
end
