# frozen_string_literal: true

require_relative "lib/webmention/version"

Gem::Specification.new do |spec|
  spec.required_ruby_version = ">= 3.0"

  spec.name = "webmention"
  spec.version = Webmention::VERSION
  spec.authors = ["Jason Garber"]
  spec.email = ["jason@sixtwothree.org"]

  spec.summary = "Webmention notification client"
  spec.description = "A Ruby gem for sending and verifying Webmention notifications."
  spec.homepage = "https://github.com/indieweb/webmention-client-ruby"
  spec.license = "Apache-2.0"

  spec.files = Dir["lib/**/*"].reject { |f| File.directory?(f) }
  spec.files += %w[LICENSE CHANGELOG.md CONTRIBUTING.md README.md USAGE.md]
  spec.files += %w[webmention.gemspec]

  spec.require_paths = ["lib"]

  spec.metadata = {
    "bug_tracker_uri" => "#{spec.homepage}/issues",
    "changelog_uri" => "#{spec.homepage}/releases/tag/v#{spec.version}",
    "rubygems_mfa_required" => "true",
    "source_code_uri" => "#{spec.homepage}/tree/v#{spec.version}"
  }

  spec.add_runtime_dependency "http", "~> 5.2"
  spec.add_runtime_dependency "indieweb-endpoints", "~> 9.0"
  spec.add_runtime_dependency "nokogiri", ">= 1.16"
end
