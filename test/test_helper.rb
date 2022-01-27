# frozen_string_literal: true

# Require SimpleCov first!
require 'simplecov'

require 'minitest/autorun'
require 'minitest/reporters'
require 'webmock/minitest'

Minitest::Reporters.use! Minitest::Reporters::DefaultReporter.new

module TestFixtures
  SAMPLE_POST_HTML = File.read(File.join(Dir.pwd, 'test', 'support', 'sample_post.html'))
  SAMPLE_POST_HTML_ANCHORS_ONLY = File.read(File.join(Dir.pwd, 'test', 'support', 'sample_post_anchors_only.html'))
  SAMPLE_POST_HTML_NO_LINKS = File.read(File.join(Dir.pwd, 'test', 'support', 'sample_post_no_links.html'))
end

require 'webmention'
