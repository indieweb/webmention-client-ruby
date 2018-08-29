lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'webmention/version'

Gem::Specification.new do |spec|
  spec.required_ruby_version = ['>= 2.4', '< 2.7']

  spec.name          = 'webmention'
  spec.version       = Webmention::VERSION
  spec.authors       = ['Aaron Parecki', 'Nat Welch']
  spec.email         = ['aaron@parecki.com']

  spec.summary       = 'Webmention and pingback notification client'
  spec.description   = 'A Ruby gem for sending webmention and pingback notifications.'
  spec.homepage      = 'https://github.com/indieweb/webmention-client-ruby'
  spec.license       = 'Apache-2.0'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }

  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'minitest', '~> 5.11'
  spec.add_development_dependency 'minitest-reporters', '~> 1.3'
  spec.add_development_dependency 'rake', '~> 12.3'
  spec.add_development_dependency 'rubocop', '~> 0.64.0'
  spec.add_development_dependency 'simplecov', '~> 0.16.1'
  spec.add_development_dependency 'simplecov-console', '~> 0.4.2'
  spec.add_development_dependency 'webmock', '~> 3.5'

  spec.add_runtime_dependency 'absolutely', '~> 1.1'
  spec.add_runtime_dependency 'addressable', '~> 2.5'
  spec.add_runtime_dependency 'http', '~> 3.3'
  spec.add_runtime_dependency 'nokogiri', '~> 1.9'
  spec.add_runtime_dependency 'webmention-endpoint', '~> 2.0'
end
