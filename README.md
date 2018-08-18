# webmention-client-ruby

**A Ruby gem for sending [Webmention](https://indieweb.org/Webmention) and [Pingback](https://indieweb.org/pingback) notifications.**

[![Gem](https://img.shields.io/gem/v/webmention.svg?style=for-the-badge)](https://rubygems.org/gems/webmention)
[![Downloads](https://img.shields.io/gem/dt/webmention.svg?style=for-the-badge)](https://rubygems.org/gems/webmention)
[![Build](https://img.shields.io/travis/indieweb/webmention-client-ruby/master.svg?style=for-the-badge)](https://travis-ci.org/indieweb/webmention-client-ruby)
[![Maintainability](https://img.shields.io/codeclimate/maintainability/indieweb/webmention-client-ruby.svg?style=for-the-badge)](https://codeclimate.com/github/indieweb/webmention-client-ruby)
[![Coverage](https://img.shields.io/codeclimate/c/indieweb/webmention-client-ruby.svg?style=for-the-badge)](https://codeclimate.com/github/indieweb/webmention-client-ruby/code)

## Key Features

- Crawls a given URL for mentioned URLs.
- Performs endpoint discovery on mentioned URLs.
- Sends webmentions and/or pingbacks to mentioned URLs.

## Getting Started

Before installing and using webmention-client-ruby, you'll want to have [Ruby](https://www.ruby-lang.org) 2.4 (or newer) installed. It's recommended that you use a Ruby version managment tool like [rbenv](https://github.com/rbenv/rbenv), [chruby](https://github.com/postmodern/chruby), or [rvm](https://github.com/rvm/rvm).

webmention-client-ruby is developed using Ruby 2.4.4 and is additionally tested against Ruby 2.5.1 using [Travis CI](https://travis-ci.org/indieweb/webmention-client-ruby).

## Installation

If you're using [Bundler](https://bundler.io) to manage gem dependencies, add webmention-client-ruby to your project's Gemfile:

```ruby
source 'https://rubygems.org'

gem 'webmention', '~> 0.1.6'
```

…and then run:

```sh
bundle install
```

## Usage

To send webmentions to all URLs mentioned within an h-entry:

```ruby
require 'webmention'

client = Webmention::Client.new('https://source.example.com/post/100')
sent_count = client.send_mentions

puts "Webmentions sent: #{sent_count}"
```

This example will crawl `https://source.example.com/post/100`, parse its markup for an h-entry, perform endpoint discovery on mentioned URLs, and attempt to send webmentions and/or pingbacks to mentioned URLs.

To send a webmention from a source URL to a target URL:

```ruby
require 'webmention'

source = 'https://source.example.com/post/100' # A post on your website
target = 'https://target.example.com/post/100' # A post on someone else's website

endpoint = Webmention::Endpoint.discover(target)

if endpoint
  Webmention::Client.send_mention(endpoint, source, target)
end
```

## Acknowledgments

webmention-client-ruby is written and maintained by [Aaron Parecki](https://aaronparecki.com) ([@aaronpk](https://github.com/aaronpk)) and [Nat Welch](https://natwelch.com) ([@icco](https://github.com/icco)) with help from [these additional contributors](https://github.com/indieweb/webmention-client-ruby/graphs/contributors).

To learn more about Webmention, see [indieweb.org/Webmention](https://indieweb.org/Webmention) and [webmention.net](https://webmention.net).

## License

webmention-client-ruby is freely available under the [Apache License 2.0](https://www.apache.org/licenses/LICENSE-2.0.html). See [LICENSE](https://github.com/indieweb/webmention-client-ruby/blob/master/LICENSE) for more details.
