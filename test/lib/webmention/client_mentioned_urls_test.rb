# frozen_string_literal: true

require 'test_helper'

describe Webmention::Client, :mentioned_urls do
  let(:url) { 'https://source.example.com' }

  let(:client) { Webmention::Client.new(url) }

  let(:stubbed_request) { stub_request(:get, url) }

  describe 'when rescuing an HTTP::Error' do
    before do
      stubbed_request.to_raise(HTTP::Error)
    end

    it 'raises a HttpError' do
      _ { client.mentioned_urls }.must_raise(Webmention::HttpError)
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
