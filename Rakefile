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

require 'rake/testtask'
require 'git'
require 'fileutils'

RDoc::Task.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Institutions'
  rdoc.options << '--line-numbers'
  rdoc.main = "README.rdoc"
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

Bundler::GemHelper.install_tasks

require 'rake/testtask'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = false
end

desc "Push latest RDocs to gh-pages."
task :ghpages => [:rerdoc] do
  g = Git.open(Dir.pwd)
  g.checkout(g.branch('gh-pages'))
  g.pull("origin", "gh-pages")
  FileUtils.rm_r("rdocs", :force => true)
  Dir.mkdir("rdocs")
  FileUtils.mv(Dir.glob("html/*"), "./rdocs", :force => true)
  FileUtils.rm_r("html", :force => true)
  g.add(".")
  g.commit_all("Update gh-pages.")
  g.push("origin", "gh-pages")
  g.checkout(g.branch('master'))
end

task :default => :test