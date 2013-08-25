require_relative '../../test_helper'

describe Webmention do

  it "must be defined" do
    Webmention::VERSION.wont_be_nil
  end

end
