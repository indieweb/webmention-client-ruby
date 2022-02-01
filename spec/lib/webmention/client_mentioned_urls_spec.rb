# frozen_string_literal: true

describe Webmention::Client, '#mentioned_urls' do
  subject(:client) { described_class.new(url) }

  let(:url) { 'https://source.example.com' }

  let(:stubbed_request) { stub_request(:get, url) }

  describe 'when rescuing an HTTP::Error' do
    before do
      stubbed_request.to_raise(HTTP::Error)
    end

    it 'raises a HttpError' do
      expect { client.mentioned_urls }.to raise_error(Webmention::HttpError)
    end
  end

  describe 'when response MIME type is unsupported/type' do
    before do
      stub_request(:get, url).to_return(
        headers: { 'Content-Type': 'unsupported/type' }
      )
    end

    it 'raises an UnsupportedMimeTypeError' do
      expect { client.mentioned_urls }.to raise_error(
        Webmention::UnsupportedMimeTypeError,
        'Unsupported MIME Type: unsupported/type'
      )
    end
  end

  describe 'when response MIME type is text/html' do
    before do
      stub_request(:get, url).to_return(
        body: TestFixtures::SAMPLE_POST_HTML,
        headers: { 'Content-Type': 'text/html' }
      )
    end

    it 'returns an Array' do
      mentioned_urls = [
        'https://target.example.com/post/1',
        'https://target.example.com/post/2',
        'https://target.example.com/image.jpg',
        'https://target.example.com/image-1x.jpg',
        'https://target.example.com/image-2x.jpg'
      ]

      expect(client.mentioned_urls).to eq(mentioned_urls)
    end
  end
end
