require 'spec_helper'
require 'model_tests_helper'

RSpec.describe TwoFactorableTest do
  before(:each) do
    new_user
  end

  it 'new users have a non-nil secret set' do
    expect(User.first.otp_auth_secret).to_not be_nil
  end

  it 'new users have OTP disabled by default' do
    expect(User.first.otp_enabled).to_not be_true
  end

  it 'users should have an instance of TOTP/ROTP objects' do
    u = User.first
    expect(u.time_based_otp.is_a? ROTP::TOTP).to_not be_false
    expect(u.recovery_otp.is_a? ROTP::HOTP).to_not be_false
  end

  it 'users should have their otp_auth_secret/persistence_seed set on creation' do
    expect(User.first.otp_auth_secret).to_not be_false
    expect(User.first.otp_persistence_seed).to_not be_false
  end

  it 'reset_otp_credentials should generate new secrets and disable OTP' do
    u = User.first
    u.update_attribute(:otp_enabled, true)
    expect(u.otp_enabled).to_not be_false
    otp_auth_secret = u.otp_auth_secret
    otp_persistence_seed = u.otp_persistence_seed

    u.reset_otp_credentials!
    expect(otp_auth_secret).to_not eq u.otp_auth_secret
    expect(otp_persistence_seed).to_not eq u.otp_persistence_seed
    expect(u.otp_enabled).to_not be_true
  end

  it 'reset_otp_persistence should generate new persistence_seed but NOT change the otp_auth_secret' do
    u = User.first
    u.update_attribute(:otp_enabled, true)
    expect(u.otp_enabled).to_not be_false
    otp_auth_secret = u.otp_auth_secret
    otp_persistence_seed = u.otp_persistence_seed

    u.reset_otp_persistence!
    expect(otp_auth_secret).to eq u.otp_auth_secret
    expect(otp_persistence_seed).to_not eq u.otp_persistence_seed
    expect(u.otp_enabled).to_not be_false
  end

  it 'generating a challenge, should retrieve the user later' do
    u = User.first
    u.update_attribute(:otp_enabled, true)
    challenge = u.generate_otp_challenge!

    w = User.find_valid_otp_challenge(challenge)
    expect(w.is_a? User).to_not be_false
    expect(u).to eq w
  end

  it 'expiring the challenge, should retrieve nothing' do
    u = User.first
    u.update_attribute(:otp_enabled, true)
    challenge = u.generate_otp_challenge!(1.second)
    sleep(2)

    w = User.find_valid_otp_challenge(challenge)
    expect(w).to be_nil
  end

  it 'expired challenges should not be valid' do
    u = User.first
    u.update_attribute(:otp_enabled, true)
    challenge = u.generate_otp_challenge!(1.second)
    sleep(2)

    expect(u.otp_challenge_valid?).to be_false
  end

  it 'null otp challenge' do
    u = User.first
    u.update_attribute(:otp_enabled, true)
    expect(u.validate_otp_token('')).to be_false
    expect(u.validate_otp_token(nil)).to be_false
  end

  it 'generated otp token should be valid for the user' do
    u = User.first
    u.update_attribute(:otp_enabled, true)

    secret = u.otp_auth_secret
    token = ROTP::TOTP.new(secret).now

    expect(u.validate_otp_token(token)).to be_true
  end

  it 'generated otp token, out of drift window, should be NOT valid for the user' do
    u = User.first
    u.update_attribute(:otp_enabled, true)

    secret = u.otp_auth_secret

    [3.minutes.from_now, 3.minutes.ago].each do |time|
      token = ROTP::TOTP.new(secret).at(time)
      expect(u.valid_otp_token?(token)).to be_false
    end
  end

  it 'recovery secrets should be valid, and valid only once' do
    u = User.first
    u.update_attribute(:otp_enabled, true)
    recovery = u.next_otp_recovery_tokens

    expect(u.valid_otp_recovery_token?(recovery.fetch(0))).to_not be_false
    expect(u.valid_otp_recovery_token?(recovery.fetch(0))).to be_false
    expect(u.valid_otp_recovery_token?(recovery.fetch(2))).to_not be_false
  end
end
