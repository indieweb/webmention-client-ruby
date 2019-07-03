lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'webmention/version'

Gem::Specification.new do |spec|
  spec.required_ruby_version = ['>= 2.4', '< 2.7']

  spec.name          = 'webmention'
  spec.version       = Webmention::VERSION
  spec.authors       = ['Aaron Parecki', 'Nat Welch']
  spec.email         = ['aaron@parecki.com']

  spec.summary       = 'Webmention notification client'
  spec.description   = 'A Ruby gem for sending webmention notifications.'
  spec.homepage      = 'https://github.com/indieweb/webmention-client-ruby'
  spec.license       = 'Apache-2.0'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(bin|test)/}) }

  spec.require_paths = ['lib']

  spec.metadata = {
    'bug_tracker_uri' => "#{spec.homepage}/issues",
    'changelog_uri'   => "#{spec.homepage}/blob/v#{spec.version}/CHANGELOG.md"
  }

  spec.add_development_dependency 'minitest', '~> 5.11'
  spec.add_development_dependency 'minitest-reporters', '~> 1.3'
  spec.add_development_dependency 'rake', '~> 12.3'
  spec.add_development_dependency 'reek', '~> 5.4'
  spec.add_development_dependency 'rubocop', '~> 0.72.0'
  spec.add_development_dependency 'rubocop-performance', '~> 1.4'
  spec.add_development_dependency 'simplecov', '~> 0.17.0'
  spec.add_development_dependency 'simplecov-console', '~> 0.5.0'
  spec.add_development_dependency 'webmock', '~> 3.6'

  spec.add_runtime_dependency 'absolutely', '~> 3.0'
  spec.add_runtime_dependency 'addressable', '~> 2.6'
  spec.add_runtime_dependency 'http', '~> 5.0.0.pre'
  spec.add_runtime_dependency 'indieweb-endpoints', '~> 0.6.0'
  spec.add_runtime_dependency 'nokogiri', '~> 1.10'
end
