# Load the Redmine helper
require File.expand_path(File.dirname(__FILE__) + '/../../../test/test_helper')
require 'cucumber/rails'
require 'factory_girl'
require 'capybara/rails'
require 'capybara/cucumber'
require 'database_cleaner'

FactoryGirl.definition_file_paths = [ File.expand_path('plugins/redmine_books/test/factories', Rails.root) ]
FactoryGirl.find_definitions

# load url helpers
include Rails.application.routes.url_helpers

include Capybara::DSL

DatabaseCleaner.strategy = :truncation
DatabaseCleaner.clean
