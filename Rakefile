require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "rom/sql/rake_task"

task :default => :spec

namespace :db do
  task :setup do
    require "database/config"

    ROM::SQL::RakeSupport.env = Database::Config::Rom
  end
end

task :spec do
  require 'dotenv'
  Dotenv.load!(".env.test")
  Rake::Task["db:setup"].invoke
  Rake::Task["db:migrate"].invoke
  system("rspec")
  Rake::Task["clean"].invoke
end

task :clean do
  rm_rf "spec/test.db"
end

