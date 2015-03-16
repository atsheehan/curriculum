require "rspec"
require "capybara/rspec"

require_relative "../server"

set :environment, :test

Capybara.app = Sinatra::Application
ActiveRecord::Base.logger.level = 1
