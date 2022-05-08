# frozen_string_literal: true

RSpec.describe Webmention::Client, '#send_webmentions' do
  subject(:response) { client.send_webmentions(*target_urls) }

  let(:client) { described_class.new(source_url) }

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
