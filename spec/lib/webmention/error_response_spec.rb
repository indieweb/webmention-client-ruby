# frozen_string_literal: true

RSpec.describe Webmention::ErrorResponse do
  subject(:error_response) { described_class.new('foo', request) }

  let(:request) { instance_double(Webmention::Request) }

  it { is_expected.not_to be_ok }
  it { is_expected.to have_attributes(message: 'foo', request: request) }
end
