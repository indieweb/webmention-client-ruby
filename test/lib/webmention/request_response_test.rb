require 'test_helper'

describe Webmention::Request, '#response' do
  let(:uri) { Addressable::URI.parse('https://example.com') }
  let(:request) { Webmention::GetRequest.new(uri) }
  let(:stubbed_request) { stub_request(:get, uri.to_s) }

  describe 'when rescuing an HTTP::ConnectionError' do
    before do
      stubbed_request.to_raise(HTTP::ConnectionError)
    end

    it 'raises a ConnectionError' do
      -> { request.response }.must_raise(Webmention::ConnectionError)
    end
  end

  describe 'when rescuing an HTTP::TimeoutError' do
    before do
      stubbed_request.to_raise(HTTP::TimeoutError)
    end

    it 'raises a TimeoutError' do
      -> { request.response }.must_raise(Webmention::TimeoutError)
    end
  end

  describe 'when rescuing an HTTP::Redirector::TooManyRedirectsError' do
    before do
      stubbed_request.to_raise(HTTP::Redirector::TooManyRedirectsError)
    end

    it 'raises a ConnectionError' do
      -> { request.response }.must_raise(Webmention::TooManyRedirectsError)
    end
  end
end
