require 'test_helper'

describe Webmention::Client, '#crawl' do
  let(:client) { Webmention::Client.new('http://source.example.com/post/100') }

  before do
    stub_request(:any, 'http://source.example.com/post/100').to_return(
      status: 200,
      body: TestFixtures::SAMPLE_SOURCE_POST_HTML
    )
  end

  describe 'when a valid url' do
    it 'should return a count and list of links' do
      client.crawl.must_be :>, 0
      client.links.must_include('http://target.example.com/post/4')
      client.links.must_include('http://target.example.com/post/5')
    end
  end
end
