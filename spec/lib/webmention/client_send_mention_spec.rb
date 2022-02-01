# frozen_string_literal: true

describe Webmention::Client, '#send_mention' do
  subject(:client) { described_class.new(source_url) }

  let(:source_url) { 'https://source.example.com' }
  let(:target_url) { 'https://target.example.com' }

  describe 'when rescuing an IndieWeb::Endpoints::HttpError' do
    before do
      stub_request(:get, target_url).to_raise(IndieWeb::Endpoints::HttpError)
    end

    it 'raises a HttpError' do
      expect { client.send_mention(target_url) }.to raise_error(Webmention::HttpError)
    end
  end

  describe 'when rescuing an IndieWeb::Endpoints::InvalidURIError' do
    before do
      stub_request(:get, target_url).to_raise(IndieWeb::Endpoints::InvalidURIError)
    end

    it 'raises a InvalidURIError' do
      expect { client.send_mention(target_url) }.to raise_error(Webmention::InvalidURIError)
    end
  end
end
