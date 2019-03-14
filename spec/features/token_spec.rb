require 'spec_helper'
require 'feature_specs_helper'

RSpec.feature 'Token' do
  def teardown
    Capybara.reset_sessions!
  end

  scenario 'disabling OTP after successfully enabling' do
    # log in 1fa
    user = enable_otp_and_sign_in
    expect(current_path).to eq user_credential_path
    # otp two_factor
    fill_in 'user_token', with: ROTP::TOTP.new(user.otp_auth_secret).at(Time.now)
    click_button 'Submit Token'
    expect(current_path).to eq root_path
    # disable OTP
    disable_otp

    # logout
    sign_out

    # log back in 1fa
    sign_user_in(user)

    expect(current_path).to eq root_path
  end
end
