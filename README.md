# webmention-client-ruby

**A Ruby gem for sending [Webmention](https://indieweb.org/Webmention) notifications.**

[![Gem](https://img.shields.io/gem/v/webmention.svg?logo=rubygems&style=for-the-badge)](https://rubygems.org/gems/webmention)
[![Downloads](https://img.shields.io/gem/dt/webmention.svg?logo=rubygems&style=for-the-badge)](https://rubygems.org/gems/webmention)
[![Build](https://img.shields.io/github/workflow/status/indieweb/webmention-client-ruby/CI?logo=github&style=for-the-badge)](https://github.com/indieweb/webmention-client-ruby/actions/workflows/ci.yml)
[![Maintainability](https://img.shields.io/codeclimate/maintainability/indieweb/webmention-client-ruby.svg?logo=code-climate&style=for-the-badge)](https://codeclimate.com/github/indieweb/webmention-client-ruby)
[![Coverage](https://img.shields.io/codeclimate/c/indieweb/webmention-client-ruby.svg?logo=code-climate&style=for-the-badge)](https://codeclimate.com/github/indieweb/webmention-client-ruby/code)

## Key Features

- Crawl a URL for mentioned URLs.
- Perform [endpoint discovery](https://www.w3.org/TR/webmention/#sender-discovers-receiver-webmention-endpoint) on mentioned URLs.
- Send webmentions to one or more mentioned URLs.
- Optionally include a [vouch](https://indieweb.org/Vouch) URL when sending webmentions.

## Table of Contents

- [Getting Started](#getting-started)
- [Installation](#installation)
- [Usage](#usage)
  - [Sending a webmention](#sending-a-webmention)
  - [Sending multiple webmentions](#sending-multiple-webmentions)
  - [Including a vouch URL](#including-a-vouch-url)
  - [Discovering mentioned URLs](#discovering-mentioned-urls)
  - [Exception Handling](#exception-handling)
- [Migrating to version 6](#migrating-to-version-6)
- [Contributing](#contributing)
- [Acknowledgments](#acknowledgments)
- [License](#license)

## Getting Started

Before installing and using webmention-client-ruby, you'll want to have [Ruby](https://www.ruby-lang.org) 2.6 (or newer) installed. It's recommended that you use a Ruby version managment tool like [rbenv](https://github.com/rbenv/rbenv), [chruby](https://github.com/postmodern/chruby), or [rvm](https://github.com/rvm/rvm).

webmention-client-ruby is developed using Ruby 2.6.10 and is additionally tested against Ruby 2.7, 3.0, and 3.1 using [GitHub Actions](https://github.com/indieweb/webmention-client-ruby/actions).

## Installation

If you're using [Bundler](https://bundler.io) to manage gem dependencies, add webmention-client-ruby to your project's Gemfile:

```ruby
source 'https://rubygems.org'

gem 'webmention'
```

…and then run:

```sh
bundle install
```

## Usage

### Sending a webmention

With webmention-client-ruby added to your project's `Gemfile` and installed, you may send a webmention from a source URL to a target URL:

```ruby
require 'webmention'

source = 'https://jgarber.example/post/100' # A post on your website
target = 'https://aaronpk.example/post/100' # A post on someone else's website

response = Webmention.send_webmention(source, target)
```

`Webmention.send_webmention` will return either a `Webmention::Response` or a `Webmention::ErrorResponse`. Instances of both classes respond to `ok?`. Building on the examples above:

A Webmention::ErrorResponse may be returned when:

1. The target URL does not advertise a Webmention endpoint.
2. The request to the target URL raises an `HTTP::Error` or an `OpenSSL::SSL::SSLError`.

```ruby
response.ok?
#=> false

response.class.name
#=> Webmention::ErrorResponse

response.message
#=> "No webmention endpoint found for target URL https://aaronpk.example/post/100"
```

A `Webmention::Response` will be returned in all other cases.

```ruby
response.ok?
#=> true

response.class.name
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

**Note:** `Webmention::Response` objects may return a variety of status codes that will vary depending on the endpoint's capabilities and the success or failure of the request. See [the Webmention spec](https://www.w3.org/TR/webmention/) for more on status codes on their implications. A `Webmention::Response` responding affirmatively to `ok?` _may_ also have a non-successful HTTP status code (e.g. `404 Not Found`).

### Sending multiple webmentions

To send webmentions to multiple target URLs mentioned by a source URL:

```ruby
source = 'https://jgarber.example/post/100'
targets = ['https://aaronpk.example/notes/1', 'https://adactio.example/notes/1']

Webmention.send_webmentions(source, targets)
```

`Webmention.send_webmentions` will return an Array of `Webmention::Response` and `Webmention::ErrorResponse` objects.

### Including a vouch URL

webmention-client-ruby supports submitting a [vouch](https://indieweb.org/Vouch) URL when sending webmentions:

```ruby
# Send a webmention with a vouch URL to a target URL
Webmention.send_webmention(source, target, vouch: 'https://tantek.example/notes/1')

# Send webmentions with a vouch URL to multiple target URLs
Webmention.send_webmentions(source, targets, vouch: 'https://tantek.example/notes/1')
```

### Discovering mentioned URLs

To retrieve unique URLs mentioned by a URL:

```ruby
urls = Webmention.mentioned_urls('https://jgarber.example/post/100')
```

`Webmention.mentioned_urls` will crawl the provided URL, parse the response body, and return a sorted list of unique URLs. The manner in which URLs are parsed conforms with [Section 3.2.2](https://www.w3.org/TR/webmention/#webmention-verification) of [the W3C's Webmention Recommendation](https://www.w3.org/TR/webmention/):

> The receiver **should** use per-media-type rules to determine whether the source document mentions the target URL.

In plaintext documents, webmention-client-ruby will search the source URL for absolute URLs. If the source URL is a JSON document, key/value pairs whose value is an absolute URL will be returned.

When parsing HTML documents, webmention-client-ruby will find the first [h-entry](https://microformats.org/wiki/h-entry) and search its markup for URLs. If no h-entry is found, the parser will search the document's `<body>`. HTML documents are searched for a variety of elements and attributes whose values may be (or include) URLs:

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

**Note:** Links pointing to the supplied URL (or those with internal fragment identifiers) will be rejected, but you may wish to filter the Array returned by `Webmention.mentioned_urls` before sending webmentions.

### Exception Handling

webmention-client-ruby avoids raising exceptions when making HTTP requests. As noted above, a `Webmention::ErrorResponse` should be returned in cases where an HTTP request triggers an exception.

`Webmention.mentioned_urls` _may_ raise one of two exceptions when crawling the supplied URL:

- A `NoMethodError` is raised when a `Webmention::ErrorResponse` is returned.
- A `KeyError` is raised when the response is of an unsupported MIME type.

## Migrating to version 6

webmention-client-ruby was completely rewritten for version 6 to better support new features and future development. Some notes on migrating to the new version:

- **Renamed:** for clarity and consistency, the `Webmention.send_mention` method has been renamed `Webmention.send_webmention`. Both methods use the same interface.
- **Removed:** the `Webmention.client` method has been removed in favor of the additional module methods [noted above](#usage). While the underlying `Webmention::Client` class still exists, its interface has changed and its direct usage is generally unnecessary.
- **Removed:** `Webmention::Client#send_all_mentions` has been removed in favor of `Webmention.send_webmentions`. Combine `Webmention.mentioned_urls` and `Webmention.send_webmentions` to achieve similar results.
- Exception handling has been greatly improved [as noted above](#exception-handling).

## Contributing

Interested in helping improve webmention-client-ruby? Awesome! Your help is greatly appreciated. See [CONTRIBUTING.md](https://github.com/indieweb/webmention-client-ruby/blob/main/CONTRIBUTING.md) for details.

## Acknowledgments

webmention-client-ruby is written and maintained by [Jason Garber](https://sixtwothree.org) ([@jgarber623](https://github.com/jgarber623)) with help from [these additional contributors](https://github.com/indieweb/webmention-client-ruby/graphs/contributors). Prior to 2018, webmention-client-ruby was written and maintained by [Aaron Parecki](https://aaronparecki.com) ([@aaronpk](https://github.com/aaronpk)) and [Nat Welch](https://natwelch.com) ([@icco](https://github.com/icco)).

To learn more about Webmention, see [indieweb.org/Webmention](https://indieweb.org/Webmention) and [webmention.net](https://webmention.net).

## License

webmention-client-ruby is freely available under the [Apache License 2.0](https://www.apache.org/licenses/LICENSE-2.0.html). See [LICENSE](https://github.com/indieweb/webmention-client-ruby/blob/main/LICENSE) for more details.
