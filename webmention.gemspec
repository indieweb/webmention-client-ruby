lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'webmention/version'

Gem::Specification.new do |spec|
  spec.required_ruby_version = ['>= 2.4', '< 2.8']

  spec.name          = 'webmention'
  spec.version       = Webmention::VERSION
  spec.authors       = ['Aaron Parecki', 'Nat Welch']
  spec.email         = ['aaron@parecki.com']

  spec.summary       = 'Webmention notification client'
  spec.description   = 'A Ruby gem for sending Webmention notifications.'
  spec.homepage      = 'https://github.com/indieweb/webmention-client-ruby'
  spec.license       = 'Apache-2.0'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(bin|test)/}) }

  spec.require_paths = ['lib']

  spec.metadata = {
    'bug_tracker_uri' => "#{spec.homepage}/issues",
    'changelog_uri'   => "#{spec.homepage}/blob/v#{spec.version}/CHANGELOG.md"
  }

  spec.add_development_dependency 'minitest', '~> 5.14'
  spec.add_development_dependency 'minitest-reporters', '~> 1.4'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'reek', '~> 6.0'
  spec.add_development_dependency 'rubocop', '~> 0.81.0'
  spec.add_development_dependency 'rubocop-performance', '~> 1.5'
  spec.add_development_dependency 'simplecov', '~> 0.18.5'
  spec.add_development_dependency 'simplecov-console', '~> 0.7.2'
  spec.add_development_dependency 'webmock', '~> 3.8'

  spec.add_runtime_dependency 'absolutely', '~> 3.1'
  spec.add_runtime_dependency 'addressable', '~> 2.7'
  spec.add_runtime_dependency 'http', '~> 4.4'
  spec.add_runtime_dependency 'indieweb-endpoints', '~> 2.0'
  spec.add_runtime_dependency 'nokogiri', '~> 1.10'
end
