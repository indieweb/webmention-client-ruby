require_relative '../../test_helper'

describe Webmention::Client do
  before do
  end

  describe "#supports_mentions" do
    it "should deal with html" do
      Webmention::Client.supports_webmention?("http://indiewebcamp.com/").must_equal "http://pingback.me/indiewebcamp/webmention"
    end

    it "should deal with Headers" do
      Webmention::Client.supports_webmention?("http://aaronparecki.com/").must_equal "http://aaronparecki.com/webmention.php"
    end

    it "should return false when nothing" do
      Webmention::Client.supports_webmention?("http://google.com/").must_equal false
    end
  end

  describe "#send_mentions" do
    it "should return a count" do
      @client = Webmention::Client.new "http://aaronparecki.com/"
      @client.send_mentions.must_be :>, 0
    end
  end
end
