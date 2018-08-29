require 'test_helper'

describe Webmention::Request do
  describe 'when uri is invalid' do
    it 'raises an ArgumentError' do
      error = -> { Webmention::Request.new(nil) }.must_raise(Webmention::ArgumentError)

      error.message.must_match('uri must be an Addressable::URI (given NilClass)')
    end
  end

  describe 'when params are invalid' do
    let(:uri) { Addressable::URI.parse('https://example.com') }

    it 'raises an ArgumentError' do
      error = -> { Webmention::Request.new(uri, true) }.must_raise(Webmention::ArgumentError)

      error.message.must_match('params must be an Enumerable (given TrueClass)')
    end
  end
end
