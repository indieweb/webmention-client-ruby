# frozen_string_literal: true

RSpec.describe Webmention::Request, "#perform" do
  subject(:response) { request.perform }

  let(:url) { "https://jgarber.example" }
  let(:request) { described_class.new(:get, url) }

  context "when an exception is raised" do
    before do
      stub_request(:get, url).to_raise(HTTP::ConnectionError.new("foo"))
    end

    it { is_expected.to have_attributes(message: "foo", ok?: false, request: request) }
  end

  context "when no exception is raised" do
    before { stub_request(:get, url) }

    it { is_expected.to have_attributes(code: 200, ok?: true, request: request) }
  end
end
