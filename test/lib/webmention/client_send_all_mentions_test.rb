require 'test_helper'

describe Webmention::Client, '#send_all_mentions' do
  let(:source_url) { 'https://source.example.com' }
  let(:target_url) { 'https://target.example.com' }
  let(:target_endpoint_url) { "#{target_url}/webmention" }
  let(:client) { Webmention::Client.new(source_url) }

  describe 'when no mentioned URLs found' do
    before do
      stub_request(:get, source_url).to_return(
        body: TestFixtures::SAMPLE_POST_HTML_NO_LINKS,
        headers: {
          'Content-Type': 'text/html'
        }
      )
    end

    it 'returns an array' do
      client.send_all_mentions.must_equal([])
    end
  end

  describe 'when mentioned URLs found' do
    before do
      stub_request(:get, %r{#{source_url}/.*}).to_return(
        body: TestFixtures::SAMPLE_POST_HTML_ANCHORS_ONLY,
        headers: {
          'Content-Type': 'text/html'
        }
      )

      stub_request(:get, %r{#{target_url}/.*}).to_return(
        headers: {
          Link: %(<#{target_endpoint_url}>; rel="webmention")
        }
      )

      stub_request(:post, target_endpoint_url).to_return(
        status: 200
      )
    end

    it 'returns an array' do
      mock = Minitest::Mock.new
      def mock.response; true; end

      Webmention::PostRequest.stub :new, mock do
        responses = [
          { url: "#{target_url}/post/1", response: true },
          { url: "#{target_url}/post/2", response: true }
        ]

        client.send_all_mentions.must_equal(responses)
      end
    end
  end
end
