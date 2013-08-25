require 'bundler/gem_tasks'
require 'rake/testtask'
 
Rake::TestTask.new do |t|
  t.libs << 'lib/webmention'
  t.test_files = FileList['test/lib/webmention/*_test.rb']
  t.verbose = true
end
 
task :default => :test
