# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tokens' do
  subject (:user) { User.create(email: 'mb@geemail.com', password: 'iwantabigmac1') }

  it 'can be disabled by a user after successfully enabling' do
    enable_otp_and_sign_in user

    fill_in 'user_token', with: ROTP::TOTP.new(user.otp_auth_secret).at(Time.now)
    click_button 'Submit Token'

    expect(current_path).to eq(root_path)

    disable_otp
    sign_out user
    sign_in_user user

    expect(current_path).to eq(root_path)
  end

  xit 'cannot be reused' do
    enable_otp_and_sign_in user

    prev_token = ROTP::TOTP.new(user.otp_auth_secret).at(Time.now)

    fill_in 'user_token', with: prev_token
    click_button 'Submit Token'

    expect(current_path).to eq(root_path)

    sign_out user
    sign_in_user user

    fill_in 'user_token', with: prev_token
    click_button 'Submit Token'

    expect(current_path).to eq(new_user_session_path)
  end
end
