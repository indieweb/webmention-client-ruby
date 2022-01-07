# frozen_string_literal: true

require 'test_helper'

describe Webmention::Client, :send_mention do
  let(:source_url) { 'https://source.example.com' }
  let(:target_url) { 'https://target.example.com' }

  let(:client) { Webmention::Client.new(source_url) }

  describe 'when rescuing an IndieWeb::Endpoints::HttpError' do
    before do
      stub_request(:get, target_url).to_raise(IndieWeb::Endpoints::HttpError)
    end

    it 'raises a HttpError' do
      _ { client.send_mention(target_url) }.must_raise(Webmention::HttpError)
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
end
