# frozen_string_literal: true

module FixturesHelper
  def load_fixture(file_name, file_type = 'html')
    File.read(File.join(Dir.pwd, "spec/support/fixtures/#{file_name}.#{file_type}"))
  end
end
