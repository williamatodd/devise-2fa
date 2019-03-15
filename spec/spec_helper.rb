# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
ENV['RAILS_ENV'] ||= 'test'
DEVISE_ORM = (ENV['DEVISE_ORM'] || :active_record).to_sym

require File.expand_path('dummy/config/environment', __dir__)
require "orm/#{DEVISE_ORM}"
require 'rspec'
require 'capybara/rails'
require 'capybara/rspec'

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.disable_monkey_patching!
  config.example_status_persistence_file_path = 'tmp/rspec_examples.txt'
  config.order = :random
  config.expose_dsl_globally = false
  config.shared_context_metadata_behavior = :apply_to_host_groups
end
