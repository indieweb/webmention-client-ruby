require_relative '../../test_helper'

describe Webmention::Client do
  before do
  end

  describe "#send_mentions" do
    it "should return a count" do
      @client = Webmention::Client.new "http://aaronparecki.com/"
      @client.send_mentions.must_be :>, 0
    end
  end
end
