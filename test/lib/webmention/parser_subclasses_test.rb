require 'test_helper'

describe Webmention::Parser, '.subclasses' do
  it 'returns an Array' do
    Webmention::Parser.subclasses.must_equal([Webmention::HtmlParser])
  end
end
