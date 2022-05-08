# frozen_string_literal: true

RSpec.describe Webmention::Response do
  subject(:response) { described_class.new(http_response, request) }

  let(:http_response) { instance_double(HTTP::Response) }
  let(:request) { instance_double(Webmention::Request) }

  it { is_expected.to be_ok }
  it { is_expected.to have_attributes(request: request) }
end
