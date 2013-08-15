require_relative '../../test_helper'

describe Webmention::Client do
  before do
    @client = Webmention::Client.new "http://google.com"
  end

  describe "#crawl" do
    describe "when a valid url" do
      it "should return a count" do
        @client.crawl.must_be :>, 0
      end
    end
  end
end
