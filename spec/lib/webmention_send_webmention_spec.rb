# frozen_string_literal: true

RSpec.describe Webmention, ".send_webmention" do
  subject(:response) { described_class.send_webmention(source_url, target_url) }

  let(:source_url) { "https://jgarber.example/foo" }
  let(:target_url) { "https://aaronpk.example/bar" }

  context "when target URL is not an absolute URL" do
    let(:target_url) { "/foo" }
    let(:message) { "unknown scheme: " }

    it { is_expected.to be_a(Webmention::ErrorResponse) }
    it { is_expected.to have_attributes(message: message, ok?: false) }
  end

  context "when target URL unreachable" do
    let(:message) { "Exception from WebMock" }

    before do
      stub_request(:get, target_url).to_raise(OpenSSL::SSL::SSLError)
    end

    it { is_expected.to be_a(Webmention::ErrorResponse) }
    it { is_expected.to have_attributes(message: message, ok?: false) }
  end

  context "when target URL does not advertise a Webmention endpoint" do
    let(:message) { "No webmention endpoint found for target URL #{target_url}" }

    before do
      stub_request(:get, target_url).to_return(body: load_fixture(:sample_post))
    end

    it { is_expected.to be_a(Webmention::ErrorResponse) }
    it { is_expected.to have_attributes(message: message, ok?: false) }
  end

  context "when target URL advertises a Webmention endpoint" do
    let(:webmention_endpoint) { "#{target_url}/webmention" }

    before do
      stub_request(:get, target_url).to_return(
        headers: {
          Link: %(<#{webmention_endpoint}>; rel="webmention")
        }
      )

      stub_request(:post, webmention_endpoint).to_return(status: 200)
    end

    it { is_expected.to be_a(Webmention::Response) }
    it { is_expected.to be_ok }
  end
end
