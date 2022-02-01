# frozen_string_literal: true

describe Webmention::Client do
  describe 'when not given a String' do
    it 'raises a NoMethodError' do
      expect { described_class.new(nil) }.to raise_error(NoMethodError)
    end
  end

  describe 'when given an invalid URL' do
    it 'raises an InvalidURIError' do
      expect { described_class.new('http:') }.to raise_error(Webmention::InvalidURIError)
    end
  end

  describe 'when given a relative URL' do
    it 'raises an ArgumentError' do
      expect { described_class.new('/foo') }.to raise_error(
        Webmention::ArgumentError,
        'source must be an absolute URL (e.g. https://example.com)'
      )
    end
  end
end
