module Webmention
  class GetRequest < Request
    private

    def perform_request
      HTTP.follow.headers(HTTP_HEADERS_OPTS).timeout(connect: 10, read: 10).get(@uri)
    end
  end
end
