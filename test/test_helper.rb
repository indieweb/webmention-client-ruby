# frozen_string_literal: true

# Require SimpleCov first!
require 'simplecov'

require 'minitest/autorun'
require 'minitest/reporters'
require 'webmock/minitest'

Minitest::Reporters.use! Minitest::Reporters::DefaultReporter.new

require_relative 'support/test_fixtures'

require 'webmention'
