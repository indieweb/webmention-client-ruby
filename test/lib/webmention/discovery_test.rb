require_relative '../../test_helper'

describe Webmention::Client do
  before do
    WebMock.stub_request(:any, 'http://example.com/header').to_return(
      :status => 200,
      :body => '<html>example</html>', 
      :headers => {
        'Link' => 'rel="webmention"; <http://webmention.io/example/webmention>'
      }
    )

    WebMock.stub_request(:any, 'http://example.com/html').to_return(
      :status => 200,
      :body => '<html><head><link rel="webmention" href="http://webmention.io/example/webmention"></head><body>example</body></html>'
    )

    WebMock.stub_request(:any, 'http://example.com/none').to_return(
      :status => 200,
      :body => '<html><head></head><body>example</body></html>'
    )
  end

  describe "#discover_webmention_endpoint_from_url" do
    it "should find endpoint from html head" do
      Webmention::Client.supports_webmention?("http://example.com/html").must_equal "http://webmention.io/example/webmention"
    end

    it "should find endpoint from http header" do
      Webmention::Client.supports_webmention?("http://example.com/header").must_equal "http://webmention.io/example/webmention"
    end

    it "should return false when no endpoint found" do
      Webmention::Client.supports_webmention?("http://example.com/none").must_equal false
    end
  end

  describe "#discover_webmention_endpoint_from_string" do
    it "should find rel=\"webmention\" followed by href in header" do
      Webmention::Client.discover_webmention_endpoint_from_header('rel="webmention"; <http://webmention.io/example/webmention>').must_equal "http://webmention.io/example/webmention"
    end

    it "should find rel=webmention followed by href in header" do
      Webmention::Client.discover_webmention_endpoint_from_header('rel=webmention; <http://webmention.io/example/webmention>').must_equal "http://webmention.io/example/webmention"
    end

    it "should find href followed by rel=\"webmention\" in header" do
      Webmention::Client.discover_webmention_endpoint_from_header('<http://webmention.io/example/webmention>; rel="webmention"').must_equal "http://webmention.io/example/webmention"
    end

    it "should find href followed by rel=webmention in header" do
      Webmention::Client.discover_webmention_endpoint_from_header('<http://webmention.io/example/webmention>; rel=webmention').must_equal "http://webmention.io/example/webmention"
    end

    it "should find rel=http://webmention.org followed by href in header" do
      Webmention::Client.discover_webmention_endpoint_from_header('rel="http://webmention.org"; <http://webmention.io/example/webmention>').must_equal "http://webmention.io/example/webmention"
    end

    it "should find href followed by rel=http://webmention.org in header" do
      Webmention::Client.discover_webmention_endpoint_from_header('<http://webmention.io/example/webmention>; rel="http://webmention.org"').must_equal "http://webmention.io/example/webmention"
    end

    it "should find rel=http://webmention.org/ followed by href in header" do
      Webmention::Client.discover_webmention_endpoint_from_header('rel="http://webmention.org/"; <http://webmention.io/example/webmention>').must_equal "http://webmention.io/example/webmention"
    end

    it "should find href followed by rel=http://webmention.org/ in header" do
      Webmention::Client.discover_webmention_endpoint_from_header('<http://webmention.io/example/webmention>; rel="http://webmention.org"').must_equal "http://webmention.io/example/webmention"
    end

    it "should find rel=webmention followed by href in html" do
      Webmention::Client.discover_webmention_endpoint_from_html(SampleData.rel_webmention_href).must_equal "http://webmention.io/example/webmention"
    end

    it "should find href followed by rel=webmention in html" do
      Webmention::Client.discover_webmention_endpoint_from_html(SampleData.rel_href_webmention).must_equal "http://webmention.io/example/webmention"
    end

    it "should find rel=http://webmention.org followed by href in html" do
      Webmention::Client.discover_webmention_endpoint_from_html(SampleData.rel_webmention_org_href).must_equal "http://webmention.io/example/webmention"
    end

    it "should find href followed by rel=http://webmention.org in html" do
      Webmention::Client.discover_webmention_endpoint_from_html(SampleData.rel_href_webmention_org).must_equal "http://webmention.io/example/webmention"
    end

    it "should find rel=http://webmention.org/ followed by href in html" do
      Webmention::Client.discover_webmention_endpoint_from_html(SampleData.rel_webmention_org_slash_href).must_equal "http://webmention.io/example/webmention"
    end

    it "should find href followed by rel=http://webmention.org/ in html" do
      Webmention::Client.discover_webmention_endpoint_from_html(SampleData.rel_href_webmention_org_slash).must_equal "http://webmention.io/example/webmention"
    end
    
    it "should find rel=webmention followed by relative href with path in header" do
      Webmention::Client.discover_webmention_endpoint_from_header('</example/webmention>; rel="http://webmention.org"').must_equal "/example/webmention"
    end

    it "should find rel=webmention followed by relative href with path in html" do
      Webmention::Client.discover_webmention_endpoint_from_html(SampleData.rel_webmention_relative_with_path).must_equal "/example/webmention"
    end

    it "should find rel=webmention followed by relative href without path in header" do
      Webmention::Client.discover_webmention_endpoint_from_header('<webmention.php>; rel="http://webmention.org"').must_equal "webmention.php"
    end

    it "should find rel=webmention followed by relative href without path in html" do
      Webmention::Client.discover_webmention_endpoint_from_html(SampleData.rel_webmention_relative_without_path).must_equal "webmention.php"
    end
    
    it "should find webmention in a link tag among multiple rel values" do
      Webmention::Client.discover_webmention_endpoint_from_html(SampleData.link_tag_multiple_rel_values).must_equal "http://webmention.io/example/webmention"
    end 
  end

end
