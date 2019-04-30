module Webmention
  class PostRequest < Request
    private

    def perform_request
      HTTP.follow.headers(HTTP_HEADERS_OPTS).timeout(connect: 10, read: 10).post(@uri, form: @params)
    end
  end
end
