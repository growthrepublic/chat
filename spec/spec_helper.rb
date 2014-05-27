# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec_loader'

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.include RequestHelpers, type: :request

  config.prepend_before(:each) do
    Mongoid.purge!
  end

  config.use_transactional_fixtures = false
  config.order = "random"

  config.infer_spec_type_from_file_location!
end
