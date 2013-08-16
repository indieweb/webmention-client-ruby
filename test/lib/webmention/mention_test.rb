require_relative '../../test_helper'

describe Webmention::Client do
  before do
    @client = Webmention::Client.new "http://google.com"
  end

  describe "#send_mentions" do
    describe "send_mentions" do
      it "should return a count" do
        @client.send_mentions.must_be :>, 0
      end
    end
  end
end
