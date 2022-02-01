# frozen_string_literal: true

describe Webmention::Client, '#send_all_mentions' do
  subject(:client) { described_class.new(source_url) }

  let(:source_url) { 'https://source.example.com' }
  let(:target_url) { 'https://target.example.com' }

  let :http_response_headers do
    { 'Content-Type': 'text/html' }
  end

  describe 'when no mentioned URLs found' do
    before do
      stub_request(:get, source_url).to_return(
        body: TestFixtures::SAMPLE_POST_HTML_NO_LINKS,
        headers: http_response_headers
      )
    end

    it 'returns a Hash' do
      expect(client.send_all_mentions).to eq({})
    end
  end

  describe 'when mentioned URLs found' do
    before do
      stub_request(:get, %r{#{source_url}/.*}).to_return(
        body: TestFixtures::SAMPLE_POST_HTML_ANCHORS_ONLY,
        headers: http_response_headers.merge(
          Link: %(<#{source_url}/webmention>; rel="webmention")
        )
      )

      stub_request(:get, %r{#{target_url}/.*}).to_return(
        headers: {
          Link: %(<#{target_url}/webmention>; rel="webmention")
        }
      )
    end

    it 'returns a Hash' do
      allow(Webmention::Services::HttpRequestService).to receive(:post).and_return(true)

      responses = {
        "#{target_url}/post/1" => true,
        "#{target_url}/post/2" => true,
        "#{source_url}/post/1" => true
      }

      expect(client.send_all_mentions).to eq(responses)
    end
  end
end
