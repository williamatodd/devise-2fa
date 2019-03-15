require 'spec_helper'

RSpec.feature 'Sign in', type: :feature do
  def teardown
    Capybara.reset_sessions!
  end

  scenario 'a new user should be able to sign in without using their token' do
    create_full_user

    visit new_user_session_path
    fill_in 'user_email', with: 'user@email.invalid'
    fill_in 'user_password', with: '12345678'
    page.has_content?('Log in') ? click_button('Log in') : click_button('Sign in')

    expect(current_path).to eq root_path
  end

  scenario 'a new user, just signed in, should be able to sign in and enable their OTP authentication' do
    user = sign_user_in

    visit user_token_path
    expect(page.body).to_not have_content('Your token secret')
    check 'user_otp_enabled'
    click_button 'Continue...'

    expect(current_path).to eq user_token_path
    expect(page.body).to have_content('Your token secret')
    expect(user.otp_auth_secret.nil?).to_not be_true
    expect(user.otp_persistence_seed.nil?).to_not be_true
  end

  scenario 'a new user should be able to sign in enable OTP and be prompted for their token' do
    enable_otp_and_sign_in

    expect(current_path).to eq user_credential_path
  end

  scenario 'fail token authentication' do
    enable_otp_and_sign_in
    expect(current_path).to eq user_credential_path
    fill_in 'user_token', with: '123456'
    click_button 'Submit Token'

    expect(current_path).to eq new_user_session_path
  end

  scenario 'fail blank token authentication' do
    enable_otp_and_sign_in
    expect(current_path).to eq user_credential_path
    fill_in 'user_token', with: ''
    click_button 'Submit Token'

    expect(current_path).to eq user_credential_path
  end

  scenario 'successful token authentication' do
    user = enable_otp_and_sign_in

    fill_in 'user_token', with: ROTP::TOTP.new(user.otp_auth_secret).at(Time.now)
    click_button 'Submit Token'

    expect(current_path).to eq root_path
  end

  scenario 'should fail if the the challenge times out' do
    old_timeout = User.otp_authentication_timeout
    User.otp_authentication_timeout = 1.second

    user = enable_otp_and_sign_in

    sleep(2)

    fill_in 'user_token', with: ROTP::TOTP.new(user.otp_auth_secret).at(Time.now)
    click_button 'Submit Token'

    User.otp_authentication_timeout = old_timeout
    expect(current_path).to eq new_user_session_path
  end
end
