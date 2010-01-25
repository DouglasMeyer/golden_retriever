require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "golden_retriever"
    gem.summary = %Q{Retriever fetches your resources for you.}
    gem.description = %Q{ Restful controllers will have their resources automatically loaded for them.}
    gem.email = "DouglasYMan@Yahoo.com"
    gem.homepage = "http://github.com/DouglasMeyer/golden_retriever"
    gem.authors = ["DouglasMeyer"]
    gem.add_development_dependency "riot", ">= 0"
    gem.add_development_dependency "active_support", ">= 2.3.0"
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.test_files = FileList['test/**/*_test.rb']
  test.verbose = true
end
task :default => :test
