require 'test_helper'

describe Webmention::Parser do
  let :mime_types do
    ['text/html']
  end

  let :subclasses do
    [Webmention::HtmlParser]
  end

  describe 'when response is invalid' do
    it 'raises an ArgumentError' do
      error = -> { Webmention::Parser.new(nil) }.must_raise(Webmention::ArgumentError)

      error.message.must_match('response must be an HTTP::Response (given NilClass)')
    end

    it 'raises an UnsupportedMimeTypeError' do
      response = HTTP::Response.new(body: '', status: 200, version: '1.1')

      response.stub :mime_type, 'unsupported/type' do
        error = -> { Webmention::Parser.new(response) }.must_raise(Webmention::UnsupportedMimeTypeError)

        error.message.must_match('Unsupported MIME Type: unsupported/type')
      end
    end
  end

  describe '.mime_types' do
    it 'returns an array' do
      Webmention::Parser.mime_types.must_equal(mime_types)
    end
  end

  describe '.subclasses' do
    it 'returns an array' do
      Webmention::Parser.subclasses.must_equal(subclasses)
    end
  end
end
