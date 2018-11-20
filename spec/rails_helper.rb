# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'

require 'simplecov'
SimpleCov.start 'rails'

require File.expand_path('../config/environment', __dir__)

# Prevent database truncation if the environment is production
abort('The Rails environment is running in production mode!') if Rails.env.production?

require 'spec_helper'
require 'rspec/rails'
require 'webmock/rspec'

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  # Ensure that if we are running js tests, we are using latest webpack assets
  # This will use the defaults of :js and :server_rendering meta tags
  ReactOnRails::TestHelper.configure_rspec_to_compile_assets(config)

  config.include FactoryBot::Syntax::Methods

  config.include System, type: :system
  config.include Formulaic::Dsl, type: :system

  config.use_transactional_fixtures = true

  config.infer_spec_type_from_file_location!

  config.before(:all, type: :system) do
    Capybara.server = :puma, { Silent: true }
    driven_by :selenium, using: :headless_chrome unless ENV.key? 'NOT_HEADLESS'
  end

  config.around(:each, type: :system) do |example|
    WebMock.disable!
    example.run
    WebMock.enable!
  end
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
