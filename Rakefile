require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "rom/sql/rake_task"

DEV_DB = "./dev.db"
TEST_DB = "./test.db"

task :default => :spec

namespace :db do
  task :setup do
    require "database/config"

    ROM::SQL::RakeSupport.env = Database::Config::Rom
  end

  task :fresh do
    rm_rf DEV_DB
    require 'dotenv'
    Dotenv.load!(".env")
    Rake::Task["db:setup"].invoke
    Rake::Task["db:migrate"].invoke
    Rake::Task["db:seed"].invoke
    puts "#{DEV_DB} has been deleted, re-created and re-seeded."
  end

  task :seed do
    require_relative "db/seed"
  end
end

task :spec do
  Rake::Task["clean"].invoke
  require 'dotenv'
  Dotenv.load!(".env.test")
  Rake::Task["db:setup"].invoke
  Rake::Task["db:migrate"].invoke
  system("rspec")
end

task :clean do
  rm_rf TEST_DB
end
