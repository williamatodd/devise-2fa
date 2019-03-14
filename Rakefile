#!/usr/bin/env rake
begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end
begin
  require 'rdoc/task'
rescue LoadError
  require 'rdoc/rdoc'
  require 'rake/rdoctask'
  RDoc::Task = Rake::RDocTask
end

RDoc::Task.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Foobar'
  rdoc.options << '--line-numbers'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

Bundler::GemHelper.install_tasks

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

desc 'Run Devise tests for all ORMs.'
task :tests do
  Dir[File.join(File.dirname(__FILE__), 'test', 'orm', '*.rb')].each do |file|
    orm = File.basename(file).split('.').first
    system "rake test DEVISE_ORM=#{orm}"
  end
end

desc 'Default: run tests for all ORMs.'
task default: :tests

require 'test_unit_to_rspec_converter.rb'
task :convert_to_rspec do
  converted_count = 0
  DIRECTORIES = ["test/models","test/integration","test/helpers"]
  DIRECTORIES.each do |directory|
    next unless File.exists?(directory)
    Dir.entries(directory).each do |file|
      next if IGNORED_DIRS = ['.','..','.svn','.DS_Store'].include?(File.basename(file))
      full_path = File.join(directory,file)
      if File.file?(full_path)
        test_case = TestUnitToRspecConverter.new(full_path)
        test_case.convert
        converted_count += 1
      end
    end
  end
  puts "Test::Unit to RSpec conversion finished. #{converted_count} files converted."
end
