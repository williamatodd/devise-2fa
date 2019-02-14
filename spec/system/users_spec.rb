# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users' do
  describe 'signing up' do
    it 'can sign up' do
      visit '/users/sign_up'
      fill_in 'user_email', with: 'mb@geemail.com'
      fill_in 'user_password', with: 'iwantabigmac1'
      fill_in 'user_password_confirmation', with: 'iwantabigmac1'

      click_button('Sign up')

      expect(page).to have_content 'Welcome! You have signed up successfully.'
    end
  end

  describe 'logging in' do
    subject (:user) { User.create(email: 'mb@geemail.com', password: 'iwantabigmac1') }

    it 'can login without using a token' do
      sign_in_user(user)

      expect(page).to have_content 'Signed in successfully'
    end

    context 'enabling otp' do
      before(:each) do
        sign_in user
      end

      it 'can enable otp and are prompted for its token' do
        visit user_token_path

        fill_in 'user_refresh_password', with: user.password
        click_on 'Continue'
        check 'user_otp_enabled'
        click_on 'Continue'

        user.reload
        expect(user.otp_enabled).to be true
      end
    end

    context 'with otp enabled' do
      it 'can login with the correct code' do
        enable_otp_and_sign_in user
        fill_in 'user_token', with: ROTP::TOTP.new(user.otp_auth_secret).at(Time.now)
        click_button 'Submit Token'

        expect(current_path).to eq(root_path)
      end

      it 'fails with an incorrect code' do
        enable_otp_and_sign_in user
        fill_in 'user_token', with: '123456'
        click_button 'Submit Token'

        expect(current_path).to eq(new_user_session_path)
      end

      it 'is prompted for its token immediately after signing in' do
        enable_otp_and_sign_in user

        expect(current_path).to eq(user_credential_path)
      end

      it 'fails with a blank code' do
        enable_otp_and_sign_in user
        fill_in 'user_token', with: ''
        click_button 'Submit Token'

        expect(current_path).to eq(user_credential_path)
      end

      it 'fail when the challenge times out' do
        enable_otp_and_sign_in user

        fill_in 'user_token', with: ROTP::TOTP.new(user.otp_auth_secret).at(1000.seconds.from_now)
        click_button 'Submit Token'

        expect(current_path).to eq(new_user_session_path)
      end
    end

    context 'unsuccessfully' do
      it 'fails with an invalid user' do
        visit '/users/sign_in'
        fill_in 'user_email', with: 'user@email.invalid'
        fill_in 'user_password', with: '12345678'
        click_button('Log in')

        expect(page).to have_content 'Invalid Email or password'
      end
    end
  end
end
