require 'simplecov-console'

SimpleCov.start do
  add_filter '/test/'

  formatter SimpleCov::Formatter::MultiFormatter.new([
    SimpleCov::Formatter::Console,
    SimpleCov::Formatter::HTMLFormatter
  ])
end
