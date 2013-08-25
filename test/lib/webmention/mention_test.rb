require_relative '../../test_helper'

describe Webmention::Client do
  before do
    @client = Webmention::Client.new "http://aaronparecki.com/"
  end

  describe "#supports_mentions" do
    it "should deal with html" do
      Webmention::Client.supports_webmention?("http://aaronparecki.com/").must_equal "http://aaronparecki.com/webmention.php"
    end

    it "should deal with Headers" do
      # TODO: Find a website that has an example of this.
    end

    it "should return false when nothing" do
      Webmention::Client.supports_webmention?("http://google.com/").must_equal false
    end
  end

  describe "#send_mentions" do
    it "should return a count" do
      @client.send_mentions.must_be :>, 0
    end
  end
end
