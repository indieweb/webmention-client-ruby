# frozen_string_literal: true

require 'simplecov'
require 'webmock/rspec'

require 'webmention'

module TestFixtures
  SAMPLE_POST_HTML = File.read(File.join(Dir.pwd, 'spec', 'support', 'sample_post.html'))
  SAMPLE_POST_HTML_ANCHORS_ONLY = File.read(File.join(Dir.pwd, 'spec', 'support', 'sample_post_anchors_only.html'))
  SAMPLE_POST_HTML_NO_LINKS = File.read(File.join(Dir.pwd, 'spec', 'support', 'sample_post_no_links.html'))
end
