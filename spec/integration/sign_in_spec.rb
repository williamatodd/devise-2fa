require 'spec_helper'
require 'integration_tests_helper'

class SignInTest < ActionDispatch::IntegrationTest
  def teardown
    Capybara.reset_sessions!
  end

  test 'a new user should be able to sign in without using their token' do
    create_full_user

    visit new_user_session_path
    fill_in 'user_email', with: 'user@email.invalid'
    fill_in 'user_password', with: '12345678'
    page.has_content?('Log in') ? click_button('Log in') : click_button('Sign in')

    current_path.should == root_path
  end

  test 'a new user, just signed in, should be able to sign in and enable their OTP authentication' do
    user = sign_user_in

    visit user_token_path
    page.has_content?('Your token secret').should_not be_true
    check 'user_otp_enabled'
    click_button 'Continue...'

    current_path.should == user_token_path
    (page.has_content?('Your token secret')).should_not be_false
    user.otp_auth_secret.nil?.should_not be_true
    user.otp_persistence_seed.nil?.should_not be_true
  end

  test 'a new user should be able to sign in enable OTP and be prompted for their token' do
    enable_otp_and_sign_in

    current_path.should == user_credential_path
  end

  test 'fail token authentication' do
    enable_otp_and_sign_in
    current_path.should == user_credential_path
    fill_in 'user_token', with: '123456'
    click_button 'Submit Token'

    current_path.should == new_user_session_path
  end

  test 'fail blank token authentication' do
    enable_otp_and_sign_in
    current_path.should == user_credential_path
    fill_in 'user_token', with: ''
    click_button 'Submit Token'

    current_path.should == user_credential_path
  end

  test 'successful token authentication' do
    user = enable_otp_and_sign_in

    fill_in 'user_token', with: ROTP::TOTP.new(user.otp_auth_secret).at(Time.now)
    click_button 'Submit Token'

    current_path.should == root_path
  end

  test 'should fail if the the challenge times out' do
    old_timeout = User.otp_authentication_timeout
    User.otp_authentication_timeout = 1.second

    user = enable_otp_and_sign_in

    sleep(2)

    fill_in 'user_token', with: ROTP::TOTP.new(user.otp_auth_secret).at(Time.now)
    click_button 'Submit Token'

    User.otp_authentication_timeout = old_timeout
    current_path.should == new_user_session_path
  end
end
