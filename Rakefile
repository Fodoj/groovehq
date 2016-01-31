require "bundler/gem_tasks"

begin
  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new(:spec) do |t|
    t.rspec_opts = ["--tag=~integration"] unless ENV["TRAVIS_BRANCH"] == "master"
  end

  task :default => :spec
rescue LoadError
  # no rspec available
end
