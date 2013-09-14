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
end
