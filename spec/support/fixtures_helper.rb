# frozen_string_literal: true

module FixturesHelper
  def load_fixture(filename)
    File.read(File.join(Dir.pwd, "spec/support/fixtures/#{filename}.html"))
  end
end
