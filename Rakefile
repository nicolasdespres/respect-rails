#!/usr/bin/env rake
begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

require 'yard'
YARD::Rake::YardocTask.new do |t|
  t.files = [
    'lib/**/*.rb',
    '-',
    'README.md',
    'FAQ.md',
    'RELEASE_NOTES.md',
    'RELATED_WORK.md',
  ]
end

Bundler::GemHelper.install_tasks

require 'rake/testtask'

namespace :test do

  {
    units: 'test/unit/**/*_test.rb',
    functionals: 'test/functional/**/*_test.rb',
    integration: 'test/integration/**/*_test.rb',
  }.each do |task, pattern|
    Rake::TestTask.new(task) do |t|
      t.libs << 'lib'
      t.libs << 'test'
      t.pattern = pattern
      t.verbose = false
    end
  end

  task :all => [ :units, :functionals, :integration ]

end

task :test => "test:all"
task :default => "test"
