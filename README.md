# webmention-client-ruby

**A Ruby gem for sending [Webmention](https://indieweb.org/Webmention) notifications.**

[![Gem](https://img.shields.io/gem/v/webmention.svg?style=for-the-badge)](https://rubygems.org/gems/webmention)
[![Downloads](https://img.shields.io/gem/dt/webmention.svg?style=for-the-badge)](https://rubygems.org/gems/webmention)
[![Build](https://img.shields.io/travis/indieweb/webmention-client-ruby/master.svg?style=for-the-badge)](https://travis-ci.org/indieweb/webmention-client-ruby)
[![Maintainability](https://img.shields.io/codeclimate/maintainability/indieweb/webmention-client-ruby.svg?style=for-the-badge)](https://codeclimate.com/github/indieweb/webmention-client-ruby)
[![Coverage](https://img.shields.io/codeclimate/c/indieweb/webmention-client-ruby.svg?style=for-the-badge)](https://codeclimate.com/github/indieweb/webmention-client-ruby/code)

## Key Features

- Crawls a given URL for mentioned URLs.
- Performs endpoint discovery on mentioned URLs.
- Sends webmentions to mentioned URLs.

## Getting Started

Before installing and using webmention-client-ruby, you'll want to have [Ruby](https://www.ruby-lang.org) 2.4 (or newer) installed. It's recommended that you use a Ruby version managment tool like [rbenv](https://github.com/rbenv/rbenv), [chruby](https://github.com/postmodern/chruby), or [rvm](https://github.com/rvm/rvm).

webmention-client-ruby is developed using Ruby 2.4.5 and is additionally tested against Ruby 2.5.3 and 2.6.1 using [Travis CI](https://travis-ci.org/indieweb/webmention-client-ruby).

## Installation

If you're using [Bundler](https://bundler.io) to manage gem dependencies, add webmention-client-ruby to your project's Gemfile:

```ruby
source 'https://rubygems.org'

gem 'webmention', '~> 1.0'
```

…and then run:

```sh
bundle install
```

## Usage

With webmention-client-ruby added to your project's `Gemfile` and installed, you may send a webmention from a source URL to a target URL:

```ruby
require 'webmention'

source = 'https://source.example.com/post/100'  # A post on your website
target = 'https://target.example.com/post/100'  # A post on someone else's website

Webmention.send_mention(source, target) # returns HTTP::Response
```

To send webmentions to all URLs mentioned within a source URL's [h-entry](http://microformats.org/wiki/h-entry):

```ruby
require 'webmention'

client = Webmention::Client.new('https://source.example.com/post/100')

client.mentioned_urls    # returns Array
client.send_all_mentions # returns Array
```

This example will crawl `https://source.example.com/post/100`, parse its markup for the first h-entry, perform [endpoint discovery](https://www.w3.org/TR/webmention/#sender-discovers-receiver-webmention-endpoint) on mentioned URLs, and attempt to send webmentions to those URLs.

**Note:** If no h-entry is found at the provided source URL, the `send_all_mentions` method will search the source URL's `<body>` for mentioned URLs.

The `send_all_mentions` method returns an array of hashes for each mentioned URL. Each hash contains the keys `url` (a String) and `response` (an [`HTTP::Response` object](https://github.com/httprb/http/wiki/Response-Handling)):

```ruby
[
  {
    url: 'https://target.example.com/post/100',
    response: #<HTTP::Response/1.1 200 OK {…}>
  },
  # etc. etc. etc.
]
```

If no webmention endpoint is found for a mentioned URL, the `response` key's value will be `nil`.

### Exception Handling

There are several exceptions that may be raised by webmention-client-ruby's underlying dependencies. These errors are raised as subclasses of `Webmention::Client::Error` (which itself is a subclass of `StandardError`).

From [sporkmonger/addressable](https://github.com/sporkmonger/addressable):

- `Webmention::Client::InvalidURIError`

From [httprb/http](https://github.com/httprb/http):

- `Webmention::Client::ConnectionError`
- `Webmention::Client::TimeoutError`
- `Webmention::Client::TooManyRedirectsError`

webmention-client-ruby will also raise a `Webmention::Client::UnsupportedMimeTypeError` when encountering an `HTTP::Response` instance with an unsupported MIME type.

## Contributing

Interested in helping improve webmention-client-ruby? Awesome! Your help is greatly appreciated. See [CONTRIBUTING.md](https://github.com/indieweb/webmention-client-ruby/blob/master/CONTRIBUTING.md) for details.

## Acknowledgments

webmention-client-ruby is written and maintained by [Aaron Parecki](https://aaronparecki.com) ([@aaronpk](https://github.com/aaronpk)) and [Nat Welch](https://natwelch.com) ([@icco](https://github.com/icco)) with help from [these additional contributors](https://github.com/indieweb/webmention-client-ruby/graphs/contributors).

To learn more about Webmention, see [indieweb.org/Webmention](https://indieweb.org/Webmention) and [webmention.net](https://webmention.net).

## License

webmention-client-ruby is freely available under the [Apache License 2.0](https://www.apache.org/licenses/LICENSE-2.0.html). See [LICENSE](https://github.com/indieweb/webmention-client-ruby/blob/master/LICENSE) for more details.
