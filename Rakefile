#!/usr/bin/env rake
require 'rspec/core/rake_task'
require "bundler/gem_tasks"

task :default => :spec

desc "Run specs"
task :spec do
  RSpec::Core::RakeTask.new(:spec) do |t|
    t.pattern = './spec/**/*_spec.rb'
  end
end

desc "Copies an template ruby_resty.yml file to ~/.ruby_resty.yml"
task :copy_config do
  config_file = "#{Dir.home}/.ruby_resty.yml"
  if File.exist?(config_file)
    puts "#{config_file} exists. Skipping"
  else
    source = "#{Dir.getwd}/templates/ruby_resty.yml"
    FileUtils.copy(source, config_file)
    puts "Copied config file to #{config_file}"
  end
end

namespace :test do
  desc "Starts the test server used for integration testing"
  task :server do
   `ruby ./spec/server.rb`
  end
end
