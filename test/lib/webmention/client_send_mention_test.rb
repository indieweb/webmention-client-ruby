require 'test_helper'

describe Webmention::Client, '#send_mention' do
  let(:client) { Webmention::Client.new('https://source.example.com') }
  let(:target_url) { 'https://target.example.com' }

  describe 'when rescuing a IndieWeb::Endpoints::ConnectionError' do
    before do
      stub_request(:get, target_url).to_raise(IndieWeb::Endpoints::ConnectionError)
    end

    it 'raises a ConnectionError' do
      -> { client.send_mention(target_url) }.must_raise(Webmention::ConnectionError)
    end
  end

  describe 'when rescuing a IndieWeb::Endpoints::InvalidURIError' do
    before do
      stub_request(:get, target_url).to_raise(IndieWeb::Endpoints::InvalidURIError)
    end

    it 'raises a InvalidURIError' do
      -> { client.send_mention(target_url) }.must_raise(Webmention::InvalidURIError)
    end
  end

  describe 'when rescuing a IndieWeb::Endpoints::TimeoutError' do
    before do
      stub_request(:get, target_url).to_raise(IndieWeb::Endpoints::TimeoutError)
    end

    it 'raises a TimeoutError' do
      -> { client.send_mention(target_url) }.must_raise(Webmention::TimeoutError)
    end
  end

  describe 'when rescuing a IndieWeb::Endpoints::TooManyRedirectsError' do
    before do
      stub_request(:get, target_url).to_raise(IndieWeb::Endpoints::TooManyRedirectsError)
    end

    it 'raises a TooManyRedirectsError' do
      -> { client.send_mention(target_url) }.must_raise(Webmention::TooManyRedirectsError)
    end
  end
end
