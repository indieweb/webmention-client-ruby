# frozen_string_literal: true

RSpec.describe Webmention, '.send_webmentions' do
  subject(:response) { described_class.send_webmentions(*target_urls) }

  let(:source_url) { 'https://jgarber.example/foo' }

  let(:target_urls) do
    [
      'https://aaronpk.example/bar',
      'https://adactio.example/biz',
      'https://tantek.example/baz'
    ]
  end

  before do
    target_urls.each { |target_url| stub_request(:get, target_url) }
  end

  it { is_expected.to be_a(Array) }
end
