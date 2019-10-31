require_relative 'boot'

require 'rails'
require 'active_model/railtie'
unless ENV['BUNDLE_GEMFILE'].include?('mongodb')
  require 'active_record/railtie'
end
require 'action_controller/railtie'
require 'action_view/railtie'
require 'sprockets/railtie'
require 'rails/test_unit/railtie'

Bundler.require(*Rails.groups)
require 'devise-2fa'
require 'devise'

module Dummy
  class Application < Rails::Application
    config.load_defaults 5.0
    unless ENV['BUNDLE_GEMFILE'].include?('mongodb')
      Rails.application.config.active_record.sqlite3.represent_boolean_as_integer = true
    end
  end
end
