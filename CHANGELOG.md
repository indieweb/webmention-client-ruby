# Changelog

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
