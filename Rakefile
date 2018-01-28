require "bundler/gem_tasks"
require "rspec/core/rake_task"

# wtf is this?
# RSpec::Core::RakeTask.new(:spec)

task :default => :test

task :dev do
  ENV['DATABASE_URL'] = 'sqlite://./dev.db'
  # couldn't figure out how to use the rakefile besides running shell commands :(
  sh 'bin/console'
end

task :test do
  sh 'rspec'
end

# should we clean up test.db here?
