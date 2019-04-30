require 'test_helper'

describe Webmention::Parser, '.mime_types' do
  it 'returns an Array' do
    Webmention::Parser.mime_types.must_equal(['text/html'])
  end
end
