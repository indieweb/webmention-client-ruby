# frozen_string_literal: true

RSpec.describe Webmention, '.verify_webmention' do
  subject(:verification) { described_class.verify_webmention(source_url, target_url) }

  let(:source_url) { 'https://jgarber.example/foo' }
  let(:target_url) { 'https://aaronpk.example/bar' }

  context 'when source URL does not link to target URL' do
    before do
      stub_request(:get, source_url).to_return(
        body: load_fixture(:sample_post_no_links),
        headers: {
          'Content-Type': 'text/html'
        }
      )
    end

    it { is_expected.to be(false) }
  end

  context 'when source URL links to target URL' do
    before do
      stub_request(:get, source_url).to_return(
        body: %({"url":"#{target_url}"}),
        headers: {
          'Content-Type': 'application/json'
        }
      )
    end

    it { is_expected.to be(true) }
  end
end
