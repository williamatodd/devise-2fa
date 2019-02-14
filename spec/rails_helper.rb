# frozen_string_literal: true
require "rails/all"
require "dummy/config/application"
require 'bundler/setup'

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

