# frozen_string_literal: true

require 'pry-byebug'

require 'simplecov'
require 'webmock/rspec'

require 'webmention'

Dir.glob(File.join(__dir__, 'support/**/*.rb')).each { |f| require_relative f }

RSpec.configure do |config|
  config.include FixturesHelper

  config.disable_monkey_patching!
end
