require_relative '../../test_helper'

describe Webmention::Client do
  before do
    WebMock.stub_request(:any, 'http://source.example.com/post/100').to_return(
      :status => 200,
      :body => SampleData.sample_source_post_html,
      :headers => {}
    )

    WebMock.stub_request(:any, 'http://target.example.com/post/4').to_return(
      :status => 200,
      :body => SampleData.rel_webmention_href,
      :headers => {}
    )

    WebMock.stub_request(:any, 'http://target.example.com/post/5').to_return(
      :status => 200,
      :body => '',
      :headers => {
        'Link' => 'rel="webmention"; <http://webmention.io/example/webmention>'
      }
    )

    WebMock.stub_request(:any, 'http://webmention.io/example/webmention').to_return(
      :status => 200
    )

    @client = Webmention::Client.new "http://source.example.com/post/100"
  end

  describe "#send_mentions" do
    it "should return number of mentions sent" do
      @client = Webmention::Client.new "http://source.example.com/post/100"
      @client.send_mentions.must_equal 2
    end
  end
end
