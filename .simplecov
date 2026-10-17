# frozen_string_literal: true

formatters = [SimpleCov::Formatter::HTMLFormatter]

if RSpec.configuration.files_to_run.length > 1
  require "simplecov-console"

  formatters << SimpleCov::Formatter::Console
end

SimpleCov.enable_coverage :branch
SimpleCov.formatter SimpleCov::Formatter::MultiFormatter.new(formatters)
