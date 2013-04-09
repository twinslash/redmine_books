# Load the Redmine helper
require File.expand_path(File.dirname(__FILE__) + '/../../../test/test_helper')
require 'factory_girl'

FactoryGirl.definition_file_paths = [ File.expand_path('plugins/redmine_books/test/factories', Rails.root) ]
FactoryGirl.find_definitions
