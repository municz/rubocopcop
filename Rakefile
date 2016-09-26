require 'rake/testtask'
require 'fileutils'

Rake::TestTask.new do |t|
  t.libs << '.'
  t.test_files = FileList['*_test.rb']
  t.verbose = true
  t.warning = false
end

desc Rake::Task['test'].comment

require 'rubocop/rake_task'
RuboCop::RakeTask.new

task default: [:rubocop, :test]
