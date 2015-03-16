require "sinatra/activerecord/rake"
require "rspec/core/rake_task"

namespace :db do
  task :load_config do
    require "./server"
  end
end

RSpec::Core::RakeTask.new(:spec)
