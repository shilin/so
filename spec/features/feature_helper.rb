require_relative '../rails_helper'

Capybara.javascript_driver = :webkit

OmniAuth.config.test_mode = true

RSpec.configure do |config|
  config.use_transactional_fixtures = false

  config.include FeaturesMacros, type: :feature
  config.include MockOmniAuthMacros, type: :feature

  config.before(:each) do
    OmniAuth.config.mock_auth[:facebook] = nil
    OmniAuth.config.mock_auth[:twitter] = nil
  end

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
