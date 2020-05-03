require 'test_helper'

describe Webmention::Client, :send_mention do
  let(:source_url) { 'https://source.example.com' }
  let(:target_url) { 'https://target.example.com' }
  let(:logger) { NullLogger.new }

  let(:client) { Webmention::Client.new(source_url, logger: logger) }

  describe 'when rescuing an IndieWeb::Endpoints::ConnectionError' do
    before do
      stub_request(:get, target_url).to_raise(IndieWeb::Endpoints::ConnectionError)
    end

    it 'raises a ConnectionError' do
      _ { client.send_mention(target_url) }.must_raise(Webmention::ConnectionError)
    end
  end

  describe 'when rescuing an IndieWeb::Endpoints::InvalidURIError' do
    before do
      stub_request(:get, target_url).to_raise(IndieWeb::Endpoints::InvalidURIError)
    end

    it 'raises a InvalidURIError' do
      _ { client.send_mention(target_url) }.must_raise(Webmention::InvalidURIError)
    end
  end

  describe 'when rescuing an IndieWeb::Endpoints::TimeoutError' do
    before do
      stub_request(:get, target_url).to_raise(IndieWeb::Endpoints::TimeoutError)
    end

    it 'raises a TimeoutError' do
      _ { client.send_mention(target_url) }.must_raise(Webmention::TimeoutError)
    end
  end

  describe 'when rescuing an IndieWeb::Endpoints::TooManyRedirectsError' do
    before do
      stub_request(:get, target_url).to_raise(IndieWeb::Endpoints::TooManyRedirectsError)
    end

    it 'raises a TooManyRedirectsError' do
      _ { client.send_mention(target_url) }.must_raise(Webmention::TooManyRedirectsError)
    end
  end
end
