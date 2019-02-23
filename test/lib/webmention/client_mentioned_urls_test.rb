require 'test_helper'

describe Webmention::Client, '#mentioned_urls' do
  let(:client) { Webmention::Client.new('https://example.com') }

  describe 'when response MIME type is unsupported/type' do
    before do
      stub_request(:get, 'https://example.com').to_return(
        headers: {
          'Content-Type': 'unsupported/type'
        }
      )
    end

    it 'raises an UnsupportedMimeTypeError' do
      error = -> { client.mentioned_urls }.must_raise(Webmention::UnsupportedMimeTypeError)

      error.message.must_match('Unsupported MIME Type: unsupported/type')
    end
  end

  describe 'when response MIME type is text/html' do
    before do
      stub_request(:get, 'https://example.com').to_return(
        body: TestFixtures::SAMPLE_POST_HTML,
        headers: {
          'Content-Type': 'text/html'
        }
      )
    end

    it 'returns an array' do
      mentioned_urls = [
        'https://target.example.com/post/1',
        'https://target.example.com/post/2',
        'https://target.example.com/image.jpg',
        'https://target.example.com/image-1x.jpg',
        'https://target.example.com/image-2x.jpg'
      ]

      client.mentioned_urls.must_equal(mentioned_urls)
    end
  end
end
