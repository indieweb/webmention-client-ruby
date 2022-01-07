# frozen_string_literal: true

require 'simplecov_json_formatter'
require 'simplecov-console'

SimpleCov.start do
  add_filter '/test/'

  formatter SimpleCov::Formatter::MultiFormatter.new(
    [
      SimpleCov::Formatter::Console,
      SimpleCov::Formatter::HTMLFormatter,
      SimpleCov::Formatter::JSONFormatter
    ]
  )
end
