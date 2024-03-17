# Using webmention-client-ruby

Before using webmention-client-ruby, please read the [Getting Started](https://github.com/indieweb/webmention-client-ruby/blob/main/README.md#getting-started) and [Installation](https://github.com/indieweb/webmention-client-ruby/blob/main/README.md#installation) sections of the project's [README.md](https://github.com/indieweb/webmention-client-ruby/blob/main/README.md).

## Sending a webmention

With webmention-client-ruby installed, you may send a webmention from a source URL to a target URL:

```ruby
require "webmention"

source = "https://jgarber.example/post/100" # A post on your website
target = "https://aaronpk.example/post/100" # A post on someone else's website

response = Webmention.send_webmention(source, target)
```

`Webmention.send_webmention` will return either a `Webmention::Response` or a `Webmention::ErrorResponse`. Instances of both classes respond to `ok?`. Building on the examples above:

A `Webmention::ErrorResponse` may be returned when:

1. The target URL does not advertise a Webmention endpoint.
2. The request to the target URL raises an `HTTP::Error` or an `OpenSSL::SSL::SSLError`.

```ruby
response.ok?
#=> false

response.class
#=> Webmention::ErrorResponse

response.message
#=> "No webmention endpoint found for target URL https://aaronpk.example/post/100"
```

A `Webmention::Response` will be returned in all other cases.

```ruby
response.ok?
#=> true

response.class
#=> Webmention::Response
```

Instances of `Webmention::Response` include useful methods delegated to the underlying `HTTP::Response` object:

```ruby
response.headers   #=> HTTP::Headers
response.body      #=> HTTP::Response::Body
response.code      #=> Integer
response.reason    #=> String
response.mime_type #=> String
response.uri       #=> HTTP::URI
```

> [!NOTE]
> `Webmention::Response` objects may return a variety of status codes that will vary depending on the endpoint's capabilities and the success or failure of the request. See [the Webmention spec](https://www.w3.org/TR/webmention/) for more on status codes on their implications. A `Webmention::Response` responding affirmatively to `ok?` _may_ also have a non-successful HTTP status code (e.g. `404 Not Found`).

## Sending multiple webmentions

To send webmentions to multiple target URLs mentioned by a source URL:

```ruby
source = "https://jgarber.example/post/100"
targets = ["https://aaronpk.example/notes/1", "https://adactio.example/notes/1"]

responses = Webmention.send_webmentions(source, targets)
```

`Webmention.send_webmentions` will return an array of `Webmention::Response` and `Webmention::ErrorResponse` objects.

## Including a vouch URL

webmention-client-ruby supports submitting a [vouch](https://indieweb.org/Vouch) URL when sending webmentions:

```ruby
# Send a webmention with a vouch URL to a target URL
Webmention.send_webmention(source, target, vouch: "https://tantek.example/notes/1")

# Send webmentions with a vouch URL to multiple target URLs
Webmention.send_webmentions(source, targets, vouch: "https://tantek.example/notes/1")
```

## Discovering mentioned URLs

To retrieve unique URLs mentioned by a URL:

```ruby
urls = Webmention.mentioned_urls("https://jgarber.example/post/100")
```

`Webmention.mentioned_urls` will crawl the provided URL, parse the response body, and return a sorted list of unique URLs. Response bodies are parsed using MIME type-specific rules as noted in the [Verifying a webmention](#verifying-a-webmention) section below.

When parsing HTML documents, webmention-client-ruby will find the first [h-entry](https://microformats.org/wiki/h-entry) and search its markup for URLs. If no h-entry is found, the parser will search the document's `<body>`.

> [!NOTE]
> Links pointing to the supplied URL (or those with internal fragment identifiers) will be rejected. You may wish to additionally filter the results returned by `Webmention.mentioned_urls` before sending webmentions.

## Verifying a webmention

webmention-client-ruby verifies [HTML](https://www.w3.org/TR/html/), [JSON](https://json.org), and plaintext files in accordance with [Section 3.2.2](https://www.w3.org/TR/webmention/#webmention-verification) of [the W3C's Webmention Recommendation](https://www.w3.org/TR/webmention/):

> The receiver **should** use per-media-type rules to determine whether the source document mentions the target URL.

In plaintext documents, webmention-client-ruby will search the source URL for exact matches of the target URL. If the source URL is a JSON document, key/value pairs whose value equals the target URL are matched.

HTML documents are searched for a variety of elements and attributes whose values may be (or include) URLs:

| Element      | Attributes      |
|:-------------|:----------------|
| `a`          | `href`          |
| `area`       | `href`          |
| `audio`      | `src`           |
| `blockquote` | `cite`          |
| `del`        | `cite`          |
| `embed`      | `src`           |
| `img`        | `src`, `srcset` |
| `ins`        | `cite`          |
| `object`     | `data`          |
| `q`          | `cite`          |
| `source`     | `src`, `srcset` |
| `track`      | `src`           |
| `video`      | `src`           |

To verify a received webmention:

```ruby
# Verify that a source URL links to a target URL
verification = Webmention.verify_webmention(source, target)

# Verify that a source URL links to a target URL and that the vouch URL mentions
# the source URL's domain
verification = Webmention.verify_webmention(source, target, vouch: "https://tantek.example/notes/1")
```

`Webmention.verify_webmention` returns an instance of `Webmention::Verification` which includes the following methods (each returns either `true` or `false`):

```ruby
verification.source_mentions_target?
verification.verified?
verification.verify_vouch?
verification.vouch_mentions_source?
```

> [!NOTE]
> `Webmention.verify_webmention` parses HTML documents using the same rules outlined in [Discovering mentioned URLs](#discovering-mentioned-urls).

## Exception Handling

webmention-client-ruby avoids raising exceptions when making HTTP requests. As noted above, a `Webmention::ErrorResponse` should be returned in cases where an HTTP request triggers an exception.

When crawling the supplied URL, `Webmention.mentioned_urls` _may_ raise a `NoMethodError` if:

- a `Webmention::ErrorResponse` is returned, or
- the response is of an unsupported MIME type.
