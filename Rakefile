require "bundler/gem_tasks"

begin
  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new(:spec) do |t|
    travis_master = ENV["TRAVIS_BRANCH"] == "master" && ENV["TRAVIS_PULL_REQUEST"] == "false"
    t.rspec_opts = ["--tag=~integration"] unless travis_master
  end

  task :default => :spec
rescue LoadError
  # no rspec available
end
