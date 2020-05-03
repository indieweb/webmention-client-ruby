require 'test_helper'

describe Webmention::Client, :send_all_mentions do
  let(:source_url) { 'https://source.example.com' }
  let(:target_url) { 'https://target.example.com' }
  let(:logger) { NullLogger.new }

  let :http_response_headers do
    { 'Content-Type': 'text/html' }
  end

  let(:client) { Webmention::Client.new(source_url, logger: logger) }

  describe 'when no mentioned URLs found' do
    before do
      stub_request(:get, source_url).to_return(
        body:    TestFixtures::SAMPLE_POST_HTML_NO_LINKS,
        headers: http_response_headers
      )
    end

    it 'returns a Hash' do
      _(client.send_all_mentions).must_equal({})
    end
  end

  describe 'when mentioned URLs found' do
    before do
      stub_request(:get, %r{#{source_url}/.*}).to_return(
        body:    TestFixtures::SAMPLE_POST_HTML_ANCHORS_ONLY,
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
      Webmention::Services::HttpRequestService.stub :post, true do
        responses = {
          "#{target_url}/post/1" => true,
          "#{target_url}/post/2" => true,
          "#{source_url}/post/1" => true
        }

        _(client.send_all_mentions).must_equal(responses)
      end
    end
  end
end
