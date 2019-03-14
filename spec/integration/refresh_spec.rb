require 'spec_helper'
require 'integration_tests_helper'

RSpec.feature 'Refresh' do
  before(:each) do
    @old_refresh = User.otp_credentials_refresh
    User.otp_credentials_refresh = 1.second
  end

  def teardown
    User.otp_credentials_refresh = @old_refresh
    Capybara.reset_sessions!
  end

  it 'a user that just signed in should be able to access their OTP settings without refreshing' do
    sign_user_in

    visit user_token_path
    expect(current_path).to eq user_token_path
  end

  it 'a user should be prompted for credentials when the credentials_refresh time is expired' do
    sign_user_in
    visit user_token_path
    expect(current_path).to eq user_token_path
    sleep(2)

    visit user_token_path
    expect(current_path).to eq refresh_user_credential_path
  end

  it 'a user should be able to access their OTP settings after refreshing' do
    sign_user_in
    visit user_token_path
    expect(current_path).to eq user_token_path
    sleep(2)

    visit user_token_path
    expect(current_path).to eq refresh_user_credential_path
    fill_in 'user_refresh_password', with: '12345678'
    click_button 'Continue...'
    expect(current_path).to eq user_token_path
  end

  it 'a user should NOT be able to access their OTP settings unless refreshing' do
    sign_user_in
    visit user_token_path
    expect(current_path).to eq user_token_path
    sleep(2)

    visit user_token_path
    expect(current_path).to eq refresh_user_credential_path
    fill_in 'user_refresh_password', with: '12345670'
    click_button 'Continue...'
    expect(current_path).to eq refresh_user_credential_path
  end

  it 'user should be asked their OTP challenge in order to refresh, if they have OTP' do
    enable_otp_and_sign_in_with_otp

    sleep(2)
    visit user_token_path
    expect(current_path).to eq refresh_user_credential_path
    fill_in 'user_refresh_password', with: '12345678'
    click_button 'Continue...'

    expect(current_path).to eq refresh_user_credential_path
  end

  it 'user should be finally be able to access their settings, if they provide both a password and a valid OTP token' do
    user = enable_otp_and_sign_in_with_otp

    sleep(2)
    visit user_token_path
    expect(current_path).to eq refresh_user_credential_path
    fill_in 'user_refresh_password', with: '12345678'
    fill_in 'user_token', with: ROTP::TOTP.new(user.otp_auth_secret).at(Time.now)
    click_button 'Continue...'

    expect(current_path).to eq user_token_path
  end

  it 'and rejected when the token is blank or null' do
    user = enable_otp_and_sign_in_with_otp

    sleep(2)
    visit user_token_path
    expect(current_path).to eq refresh_user_credential_path
    fill_in 'user_refresh_password', with: '12345678'
    fill_in 'user_token', with: ''
    click_button 'Continue...'

    expect(current_path).to eq refresh_user_credential_path
  end
end
