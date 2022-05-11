# frozen_string_literal: true

RSpec.describe Webmention::Parsers::PlaintextParser, '#results' do
  subject(:results) { described_class.new(response_body, 'https://jgarber.example/foo').results }

  context 'when response body contains no URLs' do
    let(:response_body) { load_fixture(:sample_post_no_links, 'txt') }

    it { is_expected.to eq([]) }
  end

  context 'when response body contains URLs' do
    let(:response_body) { load_fixture(:sample_post, 'txt') }

    it { is_expected.to eq(['https://aaronpk.example/post/100']) }
  end
end
