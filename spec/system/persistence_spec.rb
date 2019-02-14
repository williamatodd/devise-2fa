# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Persistence' do
  subject (:user) { User.create(email: 'mb@geemail.com', password: 'iwantabigmac1') }

  it 'requests the the otp challenge every log in' do
    enable_otp_and_sign_in user
    otp_challenge_for user

    visit user_token_path

    expect(current_path).to eq(user_token_path)

    sign_out user
    sign_in_user user

    expect(current_path).to eq(user_credential_path)
  end

  it 'a user should be able to set their browser as trusted' do
    # log in 1fa
    enable_otp_and_sign_in user
    otp_challenge_for user

    visit user_token_path
    expect(current_path).to eq(user_token_path)

    click_link('Trust this browser')

    expect(page).to have_content 'This browser is trusted'
    sign_out user

    sign_in_user user

    expect(current_path).to eq(root_path)
  end

  it 'trusted status should expire' do
    User.otp_trust_persistence = 1
    user.reload
    enable_otp_and_sign_in user
    otp_challenge_for user

    visit user_token_path
    expect(current_path).to eq(user_token_path)

    click_link('Trust this browser')
    expect(page).to have_content 'This browser is trusted'

    sign_out user
    sleep User.otp_trust_persistence.to_i

    sign_in_user user

    expect(current_path).to eq(user_credential_path)
  end
end
