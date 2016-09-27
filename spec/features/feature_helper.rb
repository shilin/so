# frozen_string_literal: true
require_relative '../rails_helper'

Capybara.javascript_driver = :webkit

RSpec.configure do |config|
  config.use_transactional_fixtures = false

  config.include FeaturesMacros, type: :feature
  config.include SphinxMacros, type: :sphinx

  config.before(:each) do
    # DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.strategy = :truncation
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
