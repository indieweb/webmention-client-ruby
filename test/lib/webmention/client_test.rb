require 'test_helper'

describe Webmention::Client, '#new' do
  let(:described_class) { Webmention::Client }

  describe 'when a valid url' do
    it 'should not throw an error for http' do
      client = described_class.new('http://google.com')

      client.url.must_be_instance_of(URI::HTTP)
    end

    it 'should not throw an error for https' do
      client = described_class.new('https://google.com')

      client.url.must_be_instance_of(URI::HTTPS)
    end
  end

  describe 'when an invalid url' do
    it 'should raise an error for ftp' do
      -> { described_class.new('ftp://google.com') }.must_raise(ArgumentError)
    end

    it 'should raise an error for no protocol' do
      -> { described_class.new('google.com') }.must_raise(ArgumentError)
    end
  end
end
