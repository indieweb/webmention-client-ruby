require 'test_helper'

describe Webmention::Client, '#send_all' do
  let(:client) { Webmention::Client.new('https://example.com') }

  describe 'when no mentioned URLs found' do
    it 'returns an array' do
      client.stub :mentioned_urls, [] do
        client.send_all.must_equal([])
      end
    end
  end

  describe 'when mentioned URLs found' do
    before do
      stub_request(:any, 'https://example.com').to_return(
        body: TestFixtures::SAMPLE_POST_HTML,
        headers: {
          'Content-Type': 'text/html'
        }
      )
    end

    it 'returns an array' do
      response = {
        url: 'https://target.example.com/post/1',
        response: nil
      }

      client.stub :response_for_mentioned_url, response do
        client.send_all.must_equal([response, response, response, response, response])
      end
    end
  end
end
