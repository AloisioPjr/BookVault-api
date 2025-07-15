# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'

# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?

require 'rspec/rails'

# Require support files
Dir[Rails.root.join('spec/support/**/*.rb')].sort.each { |f| require f }

# Ensure the test database is up to date
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

RSpec.configure do |config|
  # Include custom authentication helpers for request specs
  config.include AuthHelper, type: :request

  # Directory for fixtures
  config.fixture_paths = [Rails.root.join('spec/fixtures')]

  config.use_transactional_fixtures = true

  # You can add more config options here if needed
end
