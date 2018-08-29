require 'test_helper'

describe Webmention::Client do
  describe 'when not given a String' do
    it 'raises an ArgumentError' do
      error = -> { Webmention::Client.new(nil) }.must_raise(Webmention::ArgumentError)

      error.message.must_match('url must be a String (given NilClass)')
    end
  end

  describe 'when given an invalid URL' do
    it 'raises an InvalidURIError' do
      -> { Webmention::Client.new('http:') }.must_raise(Webmention::InvalidURIError)
    end
  end

  describe 'when given a relative URL' do
    it 'raises an ArgumentError' do
      error = -> { Webmention::Client.new('/foo') }.must_raise(Webmention::ArgumentError)

      error.message.must_match('url must be an absolute URI (e.g. https://example.com)')
    end
  end
end
