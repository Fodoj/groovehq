require "bundler/gem_tasks"

begin
  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new(:spec) do |t|
    if ENV["TRAVIS_BRANCH"] != "master"
      t.rspec_opts = ["--tag=~integration"]
    end
  end

  task :default => :spec
rescue LoadError
  # no rspec available
end
