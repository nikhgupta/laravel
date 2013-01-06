require "bundler/gem_tasks"
require 'cucumber'
require 'cucumber/rake/task'

# setup some default rake tasks using cucumber
Cucumber::Rake::Task.new(:features) do |t|
    t.cucumber_opts = "features --format progress --tags=~@php"
end

task :default => :features
task :test => :features
