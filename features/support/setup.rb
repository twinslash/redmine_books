ENV['RAILS_ENV'] = "development"
require File.expand_path(File.dirname(__FILE__) + '/../../../../config/environment')

require 'cucumber/rails'
require 'capybara/rails'
require 'factory_girl'
require 'database_cleaner'

include Capybara::DSL

FactoryGirl.definition_file_paths = [ File.expand_path('plugins/redmine_books/test/factories', Rails.root) ]
FactoryGirl.find_definitions

DatabaseCleaner.strategy = :truncation
DatabaseCleaner.clean
