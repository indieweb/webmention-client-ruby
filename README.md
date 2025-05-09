# webmention-client-ruby

**A Ruby gem for sending and verifying [Webmention](https://indieweb.org/Webmention) notifications.**

[![Gem](https://img.shields.io/gem/v/webmention.svg?logo=rubygems&style=for-the-badge)](https://rubygems.org/gems/webmention)
[![Downloads](https://img.shields.io/gem/dt/webmention.svg?logo=rubygems&style=for-the-badge)](https://rubygems.org/gems/webmention)
[![Build](https://img.shields.io/github/actions/workflow/status/indieweb/webmention-client-ruby/ci.yml?branch=main&logo=github&style=for-the-badge)](https://github.com/indieweb/webmention-client-ruby/actions/workflows/ci.yml)

## Key Features

- Crawl a URL for mentioned URLs.
- Perform [endpoint discovery](https://www.w3.org/TR/webmention/#sender-discovers-receiver-webmention-endpoint) on mentioned URLs.
- Send webmentions to one or more mentioned URLs (and optionally include a [vouch](https://indieweb.org/Vouch) URL).
- Verify that a received webmention's source URL links to a target URL (and optionally verify that a vouch URL mentions the source URL's domain).

## Getting Started

Before installing and using webmention-client-ruby, you'll want to have [Ruby](https://www.ruby-lang.org) 2.6 (or newer) installed. Using a Ruby version managment tool like [rbenv](https://github.com/rbenv/rbenv), [chruby](https://github.com/postmodern/chruby), or [rvm](https://github.com/rvm/rvm) is recommended.

webmention-client-ruby is developed using Ruby 3.4 and is tested against additional Ruby versions using [GitHub Actions](https://github.com/indieweb/webmention-client-ruby/actions).

## Installation

Add webmention-client-ruby to your project's `Gemfile` and run `bundle install`:

```ruby
source "https://rubygems.org"

gem "webmention"
```

## Usage

See [USAGE.md](https://github.com/indieweb/webmention-client-ruby/blob/main/USAGE.md) for documentation of webmention-client-ruby's features.

## Migrating to version 6

webmention-client-ruby was completely rewritten for version 6 to better support new features and future development. Some notes on migrating to the new version:

♻️ **Renamed:** for clarity and consistency, the `Webmention.send_mention` method has been renamed `Webmention.send_webmention`. Both methods use the same interface.

❌ **Removed:** the `Webmention.client` method has been removed in favor of the additional module methods [noted above](#usage). While the underlying `Webmention::Client` class still exists, its interface has changed and its direct usage is generally unnecessary.

❌ **Removed:** `Webmention::Client#send_all_mentions` has been removed in favor of `Webmention.send_webmentions`. Combine `Webmention.mentioned_urls` and `Webmention.send_webmentions` to achieve similar results.

🛠 **Refactored:** Exception handling has been greatly improved [as noted above](#exception-handling).

## Contributing

See [CONTRIBUTING.md](https://github.com/indieweb/webmention-client-ruby/blob/main/CONTRIBUTING.md) for more on how to contribute to webmention-client-ruby. Your help is greatly appreciated!

By contributing to and participating in the development of webmention-client-ruby, you acknowledge that you have read and agree to the [IndieWeb Code of Conduct](https://indieweb.org/code-of-conduct).

## Acknowledgments

webmention-client-ruby is written and maintained by [Jason Garber](https://sixtwothree.org) ([@jgarber623](https://github.com/jgarber623)) with help from [these additional contributors](https://github.com/indieweb/webmention-client-ruby/graphs/contributors). Prior to 2018, webmention-client-ruby was written and maintained by [Aaron Parecki](https://aaronparecki.com) ([@aaronpk](https://github.com/aaronpk)) and [Nat Welch](https://natwelch.com) ([@icco](https://github.com/icco)).

To learn more about Webmention, see [indieweb.org/Webmention](https://indieweb.org/Webmention) and [webmention.net](https://webmention.net).

## License

webmention-client-ruby is freely available under the [Apache License 2.0](https://www.apache.org/licenses/LICENSE-2.0.html). See [LICENSE](https://github.com/indieweb/webmention-client-ruby/blob/main/LICENSE) for more details.
