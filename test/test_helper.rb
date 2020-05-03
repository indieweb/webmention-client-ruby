# Require SimpleCov first!
require 'simplecov'

require 'minitest/autorun'
require 'minitest/reporters'
require 'webmock/minitest'

Minitest::Reporters.use! Minitest::Reporters::DefaultReporter.new

require_relative 'support/test_fixtures'

require 'webmention'

require 'logger'

# Reduce the chatter of logging for tests
class NullLogger
  # To get the Logger API you can run this:
  #   (Logger.instance_methods.sort - Logger.methods).sort
  (Logger.instance_methods.sort - Logger.methods).each do |method_name|
    define_method(method_name) { |*_args| }
  end
end
