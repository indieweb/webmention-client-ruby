require 'test_helper'

describe Webmention::Client do
  before do
    WebMock.stub_request(:any, 'http://source.example.com/post/100').to_return(
      :status => 200,
      :body => SampleData.sample_source_post_html,
      :headers => {}
    )

    @client = Webmention::Client.new "http://source.example.com/post/100"
  end

  describe "#crawl" do
    describe "when a valid url" do
      it "should return a count and list of links" do
        @client.crawl.must_be :>, 0
        @client.links.must_include 'http://target.example.com/post/4'
        @client.links.must_include 'http://target.example.com/post/5'
      end
    end
  end
end
