require 'test_helper'

describe Webmention::Client, '.absolute_endpoint' do
  let(:described_class) { Webmention::Client }

  it 'should expand an endpoint url with a path to an absolute url based on the webmention url' do
    described_class.absolute_endpoint('/webmention', 'http://webmention.io/example/1').must_equal('http://webmention.io/webmention')
  end

  it 'should expand an endpoint url without a path to an absolute url based on the webmention url' do
    described_class.absolute_endpoint('webmention.php', 'http://webmention.io/example/1').must_equal('http://webmention.io/example/webmention.php')
  end

  it 'should take an empty endpoint url and return the webmention url' do
    described_class.absolute_endpoint('', 'http://webmention.io/example/1').must_equal('http://webmention.io/example/1')
  end
end
