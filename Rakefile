require 'rubygems'
require 'rake'

require "#{File.dirname(__FILE__)}/lib/lh2bc/version"

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "lh2bc"
    gem.summary = "Sync Lighthouse projects and tickets with Basecamp todo lists and items."
    gem.email = "timur.vafin@flatsoft.com"
    gem.homepage = "http://github.com/fs/lh2bc"
    gem.authors = ["Timur Vafin"]
  end

rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = Lh2Bc::VERSION::STRING
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "lh2bc #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

