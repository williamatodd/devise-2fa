# frozen_string_literal: true

ENV["RAILS_ENV"] ||= "test"

require "rails/all"
require "dummy/config/application"
require 'bundler/setup'
require 'rspec/rails'

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

Dummy::Application.initialize!

require 'capybara/rails'
Capybara.default_driver = :selenium
Capybara.server = :webrick

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!
  config.use_transactional_fixtures = true

  config.include Devise::Test::IntegrationHelpers, type: :system
end


def enable_otp_and_sign_in(user)
  sign_in user
  visit user_token_path

  fill_in 'user_refresh_password', with: user.password
  click_on 'Continue'
  check 'user_otp_enabled'
  click_on 'Continue'
  Capybara.reset_sessions!

  visit '/'

  fill_in 'user_email', with: user.email
  fill_in 'user_password', with: user.password
  click_button('Log in')
end

def disable_otp
  visit user_token_path
  uncheck 'user_otp_enabled'
  click_button 'Continue'
end

def sign_in_user(user)
  visit '/users/sign_in'
  fill_in 'user_email', with: user.email
  fill_in 'user_password', with: user.password
  click_button('Log in')
end

def otp_challenge_for(user)
  fill_in 'user_token', with: ROTP::TOTP.new(user.otp_auth_secret).at(Time.now)
  click_button 'Submit Token'
end

def enable_otp_and_sign_in_with_otp(user)
  enable_otp_and_sign_in(user)
  fill_in 'user_token', with: ROTP::TOTP.new(user.otp_auth_secret).at(Time.now)
  click_button 'Submit Token'
end
