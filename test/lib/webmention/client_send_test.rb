require 'test_helper'

describe Webmention::Client, '#send' do
  let(:client) { Webmention::Client.new('https://source.example.com') }
  let(:target_url) { 'https://target.example.com' }

  describe 'when rescuing a Webmention::Endpoint::ConnectionError' do
    before do
      stub_request(:any, target_url).to_raise(Webmention::Endpoint::ConnectionError)
    end

    it 'raises a ConnectionError' do
      -> { client.send(target_url) }.must_raise(Webmention::ConnectionError)
    end
  end

  describe 'when rescuing a Webmention::Endpoint::InvalidURIError' do
    before do
      stub_request(:any, target_url).to_raise(Webmention::Endpoint::InvalidURIError)
    end

    it 'raises a InvalidURIError' do
      -> { client.send(target_url) }.must_raise(Webmention::InvalidURIError)
    end
  end

  describe 'when rescuing a Webmention::Endpoint::TimeoutError' do
    before do
      stub_request(:any, target_url).to_raise(Webmention::Endpoint::TimeoutError)
    end

    it 'raises a TimeoutError' do
      -> { client.send(target_url) }.must_raise(Webmention::TimeoutError)
    end
  end

  describe 'when rescuing a Webmention::Endpoint::TooManyRedirectsError' do
    before do
      stub_request(:any, target_url).to_raise(Webmention::Endpoint::TooManyRedirectsError)
    end

    it 'raises a TooManyRedirectsError' do
      -> { client.send(target_url) }.must_raise(Webmention::TooManyRedirectsError)
    end
  end
end
