require_relative '../../test_helper'

describe Webmention::Client do
  describe "#new" do
    describe "when a valid url" do
      it "should not throw an error for http" do
        client = Webmention::Client.new "http://google.com"
        client.url.must_equal URI.parse("http://google.com")
      end

      it "should not throw an error for https" do
        client = Webmention::Client.new "https://google.com"
        client.url.must_equal URI.parse("https://google.com")
      end
    end

    describe "when an invalid url" do
      it "should raise an error for ftp" do
        lambda do
          Webmention::Client.new "ftp://google.com"
        end.must_raise(ArgumentError)
      end

      it "should raise an error for no protocol" do
        lambda do
          Webmention::Client.new "google.com"
        end.must_raise(ArgumentError)
      end
    end
  end
  
  describe "#absolute_endpoint" do
    it "should expand an endpoint url with a path to an absolute url based on the webmention url" do
      Webmention::Client.absolute_endpoint('/webmention', 'http://webmention.io/example/1').must_equal "http://webmention.io/webmention"
    end

    it "should expand an endpoint url without a path to an absolute url based on the webmention url" do
      Webmention::Client.absolute_endpoint('webmention.php', 'http://webmention.io/example/1').must_equal "http://webmention.io/example/webmention.php"
    end

    it "should take an empty endpoint url and return the webmention url" do
      Webmention::Client.absolute_endpoint('', 'http://webmention.io/example/1').must_equal "http://webmention.io/example/1"
    end
  end
end
