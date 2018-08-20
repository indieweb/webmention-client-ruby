require 'test_helper'

describe Webmention::Client, '.send_mention' do
  describe 'when rescuing from an error' do
    it 'returns false' do
      Webmention::Client.send_mention(nil, nil, nil).must_equal(false)
    end
  end
end
