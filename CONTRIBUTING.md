# Contributing to webmention-client-ruby

There are a couple ways you can help improve webmention-client-ruby:

1. Fix an existing [Issue][issues] and submit a [Pull Request][pulls].
1. Review open [Pull Requests][pulls].
1. Report a new [Issue][issues]. _Only do this after you've made sure the behavior or problem you're observing isn't already documented in an open issue._

## Getting Started

webmention-client-ruby is developed using Ruby 3.4 and is tested against additional Ruby versions using [GitHub Actions](https://github.com/indieweb/webmention-client-ruby/actions).

> [!TIP]
> This project is configured with a [Dev Container](https://containers.dev) which includes everything you'd need to contribute to webmention-client-ruby. If you use a supported code editor or IDE, you're encouraged to use the existing Dev Container setup.

Before making changes to webmention-client-ruby, you'll want to install Ruby 3.4. Using a Ruby version managment tool like [rbenv](https://github.com/rbenv/rbenv), [chruby](https://github.com/postmodern/chruby), or [rvm](https://github.com/rvm/rvm) is recommended. Once you've installed Ruby 3.4 using your method of choice, install the project's gems by running:

```sh
bundle install
```

## Making Changes

1. Fork and clone the project's repo.
2. Install development dependencies as outlined above.
3. Create a feature branch for the code changes you're looking to make: `git checkout -b my-new-feature`.
4. _Write some code!_
5. If your changes would benefit from testing, add the necessary tests and verify everything passes by running `bin/rspec`.
6. Commit your changes: `git commit -am 'Add some new feature or fix some issue'`. _(See [this excellent article](https://cbea.ms/git-commit/) for tips on writing useful Git commit messages.)_
7. Push the branch to your fork: `git push -u origin my-new-feature`.
8. Create a new [Pull Request][pulls] and we'll review your changes.

## Code Style

Code formatting conventions are defined in the `.editorconfig` file which uses the [EditorConfig](https://editorconfig.org) syntax. There are [plugins for a variety of editors](https://editorconfig.org/#download) that utilize the settings in the `.editorconfig` file. We recommended installing the EditorConfig plugin for your editor of choice.

Your bug fix or feature addition won't be rejected if it runs afoul of any (or all) of these guidelines, but following the guidelines will definitely make everyone's lives a little easier.

[issues]: https://github.com/indieweb/webmention-client-ruby/issues
[pulls]: https://github.com/indieweb/webmention-client-ruby/pulls
