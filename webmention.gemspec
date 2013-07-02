Gem::Specification.new do |s|
  s.name        = 'webmention'
  s.version     = '0.0.1'
  s.date        = '2013-07-02'
  s.homepage    = 'https://github.com/indieweb/mention-client-ruby'
  s.summary     = "A gem for sending webmention (and pingback) notifications"
  s.authors     = [
    "Aaron Parecki"
  ]
  s.email       = 'aaron@parecki.com'
  s.files       = [
    "lib/webmention.rb"
  ]
  s.add_dependency 'json'
  s.add_dependency 'rest-client'
end