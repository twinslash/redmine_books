#ENV['RAILS_ENV'] = "test"
#require File.expand_path('../../../../config/environment.rb', __FILE__)

require File.expand_path(File.dirname(__FILE__) + '/../../../test/test_helper')
require 'factory_girl'
require 'rspec/rails'

FactoryGirl.definition_file_paths = [ File.expand_path('../factories', __FILE__) ]
FactoryGirl.find_definitions

# load url helpers
RSpec::Rails::ControllerExampleGroup.instance_eval do
  include Rails.application.routes.url_helpers
end
