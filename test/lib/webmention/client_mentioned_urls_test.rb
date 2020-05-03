require 'test_helper'

describe Webmention::Client, :mentioned_urls do
  let(:url) { 'https://example.com' }
  let(:logger) { NullLogger.new }

  let(:client) { Webmention::Client.new(url, logger: logger) }

  let(:stubbed_request) { stub_request(:get, url) }

  describe 'when rescuing an HTTP::ConnectionError' do
    before do
      stubbed_request.to_raise(HTTP::ConnectionError)
    end

    it 'raises a ConnectionError' do
      _ { client.mentioned_urls }.must_raise(Webmention::ConnectionError)
    end
  end

  describe 'when rescuing an HTTP::TimeoutError' do
    before do
      stubbed_request.to_raise(HTTP::TimeoutError)
    end

    it 'raises a TimeoutError' do
      _ { client.mentioned_urls }.must_raise(Webmention::TimeoutError)
    end
  end

  describe 'when rescuing an HTTP::Redirector::TooManyRedirectsError' do
    before do
      stubbed_request.to_raise(HTTP::Redirector::TooManyRedirectsError)
    end

    it 'raises a TooManyRedirectsError' do
      _ { client.mentioned_urls }.must_raise(Webmention::TooManyRedirectsError)
    end
  end

  describe 'when response MIME type is unsupported/type' do
    before do
      stub_request(:get, url).to_return(
        headers: { 'Content-Type': 'unsupported/type' }
      )
    end

    it 'raises an UnsupportedMimeTypeError' do
      error = _ { client.mentioned_urls }.must_raise(Webmention::UnsupportedMimeTypeError)

      _(error.message).must_match('Unsupported MIME Type: unsupported/type')
    end
  end

  describe 'when response MIME type is text/html' do
    before do
      stub_request(:get, url).to_return(
        body:    TestFixtures::SAMPLE_POST_HTML,
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

      _(client.mentioned_urls).must_equal(mentioned_urls)
    end
  end
end
