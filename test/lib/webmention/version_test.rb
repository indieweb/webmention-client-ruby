require 'test_helper'

describe Webmention::VERSION do
  it 'must be defined' do
    Webmention::VERSION.wont_be_nil
  end
end
