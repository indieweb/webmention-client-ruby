lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'webmention/version'

Gem::Specification.new do |s|
  s.name          = 'webmention'
  s.version       = Webmention::VERSION
  s.date          = '2013-07-02'
  s.homepage      = 'https://github.com/indieweb/mention-client-ruby'
  s.summary       = "A gem for sending webmention (and pingback) notifications"
  s.authors       = [
    "Aaron Parecki",
    "Nat Welch"
  ]

  s.email         = 'aaron@parecki.com'

  s.files         = `git ls-files`.split($/)
  s.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]

  s.add_dependency 'json'
  s.add_dependency 'rest-client'

  s.add_development_dependency "bundler", "~> 1.3"
  s.add_development_dependency "rake"
end
