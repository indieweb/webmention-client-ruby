# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.required_ruby_version = ">= 2.7"

  spec.name = "webmention"
  spec.version = "8.0.0"
  spec.authors = ["Jason Garber"]
  spec.email = ["jason@sixtwothree.org"]

  spec.summary = "A Ruby gem for sending and verifying Webmention notifications."
  spec.description = spec.summary
  spec.homepage = "https://github.com/indieweb/webmention-client-ruby"
  spec.license = "Apache-2.0"

  spec.files = Dir["lib/**/*"].reject { |f| File.directory?(f) }
  spec.files += ["LICENSE", "CHANGELOG.md", "CONTRIBUTING.md", "README.md", "USAGE.md"]
  spec.files += ["webmention.gemspec"]

  spec.require_paths = ["lib"]

  spec.metadata = {
    "bug_tracker_uri" => "#{spec.homepage}/issues",
    "changelog_uri" => "#{spec.homepage}/releases/tag/v#{spec.version}",
    "documentation_uri" => "https://rubydoc.info/gems/#{spec.name}/#{spec.version}",
    "homepage_uri" => spec.homepage,
    "rubygems_mfa_required" => "true",
    "source_code_uri" => "#{spec.homepage}/tree/v#{spec.version}",
  }

  spec.add_dependency "http", "~> 5.3"
  spec.add_dependency "indieweb-endpoints", "~> 10.0"
  spec.add_dependency "nokogiri", ">= 1.14"
end
