# frozen_string_literal: true

RSpec.describe Webmention, ".verify_webmention" do
  subject(:verification) { described_class.verify_webmention(source_url, target_url) }

  let(:source_url) { "https://jgarber.example/post/1" }
  let(:target_url) { "https://aaronpk.example/post/2" }
  let(:vouch_url) { "https://tantek.example/post/1" }

  context "when source URL does not link to target URL" do
    let(:verification_attributes) do
      {
        source_mentions_target?: false,
        verified?: false,
        verify_vouch?: false
      }
    end

    before do
      stub_request(:get, source_url).to_return(
        body: load_fixture(:sample_post_no_links),
        headers: {
          "Content-Type": "text/html"
        }
      )
    end

    it { is_expected.to be_a(Webmention::Verification) }
    it { is_expected.to have_attributes(verification_attributes) }
  end

  context "when source URL links to target URL" do
    let(:verification_attributes) do
      {
        source_mentions_target?: true,
        verified?: true,
        verify_vouch?: false
      }
    end

    before do
      stub_request(:get, source_url).to_return(
        body: %({"url":"#{target_url}"}),
        headers: {
          "Content-Type": "application/json"
        }
      )
    end

    it { is_expected.to be_a(Webmention::Verification) }
    it { is_expected.to have_attributes(verification_attributes) }
  end

  context "when vouch URL does not link to source URL domain" do
    subject(:verification) { described_class.verify_webmention(source_url, target_url, vouch: vouch_url) }

    let(:verification_attributes) do
      {
        source_mentions_target?: true,
        verified?: false,
        verify_vouch?: true,
        vouch_mentions_source?: false
      }
    end

    before do
      stub_request(:get, source_url).to_return(
        body: load_fixture(:sample_post_anchors_only),
        headers: {
          "Content-Type": "text/html"
        }
      )

      stub_request(:get, vouch_url).to_return(
        body: load_fixture(:sample_post_no_links),
        headers: {
          "Content-Type": "text/html"
        }
      )
    end

    it { is_expected.to be_a(Webmention::Verification) }
    it { is_expected.to have_attributes(verification_attributes) }
  end

  context "when vouch URL links to source URL domain" do
    subject(:verification) { described_class.verify_webmention(source_url, target_url, vouch: vouch_url) }

    let(:verification_attributes) do
      {
        source_mentions_target?: true,
        verified?: true,
        verify_vouch?: true,
        vouch_mentions_source?: true
      }
    end

    before do
      stub_request(:get, source_url).to_return(
        body: load_fixture(:sample_post_anchors_only),
        headers: {
          "Content-Type": "text/html"
        }
      )

      stub_request(:get, vouch_url).to_return(
        body: "I vouch for:\n\nhttps://jgarber.example\nhttps://adactio.example",
        headers: {
          "Content-Type": "text/plain"
        }
      )
    end

    it { is_expected.to be_a(Webmention::Verification) }
    it { is_expected.to have_attributes(verification_attributes) }
  end
end
