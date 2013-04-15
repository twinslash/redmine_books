ENV['RAILS_ENV'] = "test"
require File.expand_path(File.dirname(__FILE__) + '/../../../../config/environment')

require 'cucumber/rails'
require 'capybara/rails'
require 'rspec/rails'
require 'factory_girl'
require 'database_cleaner'

include Capybara::DSL

FactoryGirl.definition_file_paths = [ File.expand_path('plugins/redmine_books/spec/factories', Rails.root) ]
FactoryGirl.find_definitions

DatabaseCleaner.strategy = :truncation
DatabaseCleaner.clean

module CapybaraApp
  def app; Capybara.app; end
end

World(Rails.application.routes.url_helpers)
World(Rack::Test::Methods)

World(CapybaraApp)
