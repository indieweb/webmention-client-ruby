require 'test_helper'

describe Webmention::Parser do
  describe 'when response is invalid' do
    it 'raises an ArgumentError' do
      error = -> { Webmention::Parser.new(nil) }.must_raise(Webmention::ArgumentError)

      error.message.must_match('response must be an HTTP::Response (given NilClass)')
    end

    it 'raises an UnsupportedMimeTypeError' do
      mock = Minitest::Mock.new

      def mock.is_a?(_arg); true; end

      def mock.mime_type; 'unsupported/type'; end

      HTTP::Response.stub :new, mock do
        error = -> { Webmention::Parser.new(mock) }.must_raise(Webmention::UnsupportedMimeTypeError)

        error.message.must_match('Unsupported MIME Type: unsupported/type')
      end
    end
  end
end
