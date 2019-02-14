require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)
require 'devise-2fa'
require 'devise'

module Dummy
  class Application < Rails::Application
    config.load_defaults 5.0
  end
end

