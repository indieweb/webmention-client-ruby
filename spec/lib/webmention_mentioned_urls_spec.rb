# frozen_string_literal: true

RSpec.describe Webmention, ".mentioned_urls" do
  subject(:mentioned_urls) { described_class.mentioned_urls(source_url) }

  let(:source_url) { "https://jgarber.example/foo" }

  context "when response is an ErrorResponse" do
    before do
      stub_request(:get, source_url).to_raise(OpenSSL::SSL::SSLError)
    end

    it "raises a NoMethodError" do
      expect { mentioned_urls }.to raise_error(NoMethodError)
    end
  end

  context "when response is of unsupported MIME type" do
    before do
      stub_request(:get, source_url).to_return(
        headers: {
          "Content-Type": "foo/bar"
        }
      )
    end

    it "raises a NoMethodError" do
      expect { mentioned_urls }.to raise_error(NoMethodError)
    end
  end

  context "when no mentioned URLs found" do
    before do
      stub_request(:get, source_url).to_return(
        body: load_fixture(:sample_post_no_links),
        headers: {
          "Content-Type": "text/html"
        }
      )
    end

    it { is_expected.to eq([]) }
  end

  context "when mentioned URLs found" do
    let(:extracted_urls) do
      [
        "https://aaronpk.example/image-1x.jpg",
        "https://aaronpk.example/image-2x.jpg",
        "https://aaronpk.example/image.jpg",
        "https://aaronpk.example/post/1",
        "https://aaronpk.example/post/2",
        "https://jgarber.example"
      ]
    end

    before do
      stub_request(:get, source_url).to_return(
        body: load_fixture(:sample_post),
        headers: {
          "Content-Type": "text/html"
        }
      )
    end

    it { is_expected.to eq(extracted_urls) }
  end

  context "when mentioned URLs include links to source URL" do
    let(:extracted_urls) do
      [
        "https://aaronpk.example/post/1",
        "https://aaronpk.example/post/2",
        "https://jgarber.example/post/1"
      ]
    end

    before do
      stub_request(:get, source_url).to_return(
        body: load_fixture(:sample_post_anchors_only),
        headers: {
          "Content-Type": "text/html"
        }
      )
    end

    it { is_expected.to eq(extracted_urls) }
  end
end
