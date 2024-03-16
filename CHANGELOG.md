# Changelog

> [!NOTE]
> From v8.0.0, changes are documented using [GitHub Releases](https://github.com/indieweb/webmention-client-ruby/releases). For a given release, metadata on RubyGems.org will link to that version's Release page.

## 7.0.0 / 2022-11-09

- Refactor HTML and JSON parser classes (ec58206 and 6818c05)
- Update indieweb-endpoints dependency constraint (4cd742f)
- Relax nokogiri dependency constraint (e86f3bc)
- **Breaking change:** Update development Ruby to 2.7.6 and minimum Ruby to 2.7 (5bee7dd)

## 6.0.0 / 2022-05-13

### New Features

- Top-level module methods:
  - `Webmention.send_webmention(source, target)`
  - `Webmention.send_webmentions(source, *targets)`
  - `Webmention.mentioned_urls(url)`
  - `Webmention.verify_webmention(source, target)`
- New JSON and plaintext parsers
- [Vouch](https://indieweb.org/Vouch) URL support (9829269)
- Webmention verification support (5fe5f58 and 100644)
- Fewer exceptions! HTTP response handling updated to return similar objects (`Webmention::Response` and `Webmention::ErrorResponse`).
- Fewer runtime dependencies!

### Breaking Changes

- `Webmention.send_mention` renamed to `Webmention.send_webmention`
- `Webmention.client` method removed
- `Webmention::Client#send_all_mentions` removed in favor of `Webmention.mentioned_urls` and `Webmention.send_webmentions`
- Response objects from `Webmention.send_webmention` and `Webmention.send_webmentions` have changed from instances of `HTTP::Response` to instances of `Webmention::Response` or `Webmention::ErrorResponse`
- Remove Absolutely and Addressable dependencies
- Add support for Ruby 3 (a31aae6)
- Update minimum supported Ruby version to 2.6 (e4fed8e)

### Development Changes

- Remove Reek development dependency (806bbc7)
- Update development Ruby version to 2.6.10 (7e52ec9)
- Migrate test suite to RSpec (79ac684)
- Migrate to GitHub Actions (f5a3d7a)

## 5.0.0 / 2020-12-13

- Update absolutely and indieweb-endpoints gems to v5.0 (89f4ea8)

## 4.0.0 / 2020-08-23

- **Breaking change:** Update minimum supported Ruby version to 2.5 (b2bc62f)
- Update indieweb-endpoints to 4.0 (e61588f)
- Update project Ruby version to 2.5.8 (2a626a6)

## 3.0.0 / 2020-05-19

- Reject "internal" URLs when sending webmentions (#24) (ccc82c8)
- Select only HTTP/HTTPS URLs when sending webmentions (#22) (39e5852)

## 2.2.0 / 2020-05-18

- Update absolutely and indieweb-endpoints gems (350d2ed)
- Add pry-byebug and `bin/console` script (d2c5e03)
- Move development dependencies to Gemfile per current Bundler conventions (3a2fc21)
- Update development Ruby version to 2.4.10 (4c7d1f7)

## 2.1.0 / 2020-04-06

- Refactor `BaseParser` class and remove `Registerable` module (b706229)
- Refactor `HttpRequest` and `NodeParser` classes into Service Objects (f29c073 and 7456bf1)

## 2.0.0 / 2020-01-25

- Add Ruby 2.7 to list of supported Ruby versions (c67ed14)
- Update absolutely, addressable, http, and indieweb-endpoints version constaints (986d326 and 6ba054f)
- Update development dependencies (74ac982)
- Update project Ruby version to 2.4.9 and update documentation (fd61ddf)

## 1.0.2 / 2019-08-31

- Update Addressable and WebMock gems (0b98981)
- Update project development Ruby to 2.4.7 and update documentation (882d4d3)

## 1.0.1 / 2019-07-17

- Update indieweb-endpoints (cfe6287) and rubocop (c2b7047)

## 1.0.0 / 2019-07-03

### Breaking Changes

For an instance of the `Webmention::Client` class:

- The `send_mention` no longer accepts the `full_response` argument. When a Webmention endpoint is found, the method returns an `HTTP::Response` object. Otherwise, the method returns `nil`.
- The `send_mentions` method is renamed to `send_all_mentions` and now returns a Hash whose keys are URLs and values are `HTTP::Response` objects (or `nil` when no Webmention endpoint is found at the given URL).
- The `mentioned_url` method returns an Array of URLs mentioned within given URL's first `.h-entry` (if one exists). Otherwise, it returns a list of all URLs within the given URL's `<body>`.

### Development Changes

- Removes [Bundler](https://bundler.io) as a dependency (5e1662d)
- Updates project Ruby to 2.4.6 (the latest 2.4.x release at this time) (b53a400)
- Add the [Reek](https://github.com/troessner/reek) code smell detector (eb314dc)
- Adds binstubs for more easily running common development tools (8899a22)
