require 'test_helper'

describe Webmention::Client, '#send_mentions' do
  let(:client) { Webmention::Client.new('http://source.example.com/post/100') }

  before do
    stub_request(:any, 'http://source.example.com/post/100').to_return(
      status: 202,
      body: SampleData.sample_source_post_html,
      headers: {
        'Content-Type': 'text/html'
      }
    )

    stub_request(:any, 'http://target.example.com/post/4').to_return(
      status: 202,
      body: SampleData.rel_webmention_href,
      headers: {
        'Content-Type': 'text/html'
      }
    )

    stub_request(:any, 'http://target.example.com/post/5').to_return(
      status: 202,
      headers: {
        'Link': '<http://webmention.io/example/webmention>; rel="webmention"'
      }
    )

    stub_request(:any, 'http://webmention.io/example/webmention').to_return(
      status: 202
    )
  end

  it 'should return an integer' do
    client.send_mentions.must_equal(2)
  end
end
