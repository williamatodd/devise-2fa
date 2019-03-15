require 'spec_helper'

RSpec.feature 'Persistence', type: :feature do
  before(:each) do
    @old_persistence = User.otp_trust_persistence
    User.otp_trust_persistence = 3.seconds
  end

  def teardown
    User.otp_trust_persistence = @old_persistence
    Capybara.reset_sessions!
  end

  scenario 'a user should be requested the otp challenge every log in' do
    # log in 1fa
    user = enable_otp_and_sign_in
    otp_challenge_for user

    visit user_token_path
    expect(current_path).to eq user_token_path
    sign_out
    sign_user_in

    expect(current_path).to eq user_credential_path
  end

  scenario 'a user should be able to set their browser as trusted' do
    # log in 1fa
    user = enable_otp_and_sign_in
    otp_challenge_for user

    visit user_token_path
    expect(current_path).to eq user_token_path
    click_link('Trust this browser')
    expect(page.body).to have_content('Your browser is trusted.')
    sign_out

    sign_user_in

    expect(current_path).to eq root_path
  end

  scenario 'trusted status should expire' do
    # log in 1fa
    user = enable_otp_and_sign_in
    otp_challenge_for user

    visit user_token_path
    expect(current_path).to eq user_token_path
    click_link('Trust this browser')
    expect(page.body).to have_content('Your browser is trusted.')
    sign_out

    sleep User.otp_trust_persistence.to_i + 1
    sign_user_in

    expect(current_path).to eq user_credential_path
  end
end
