require 'spec_helper'
require 'model_tests_helper'

class TwoFactorableTest < ActiveSupport::TestCase
  before(:each) do
    new_user
  end

  test 'new users have a non-nil secret set' do
    User.first.otp_auth_secret.should_not be_nil
  end

  test 'new users have OTP disabled by default' do
    User.first.otp_enabled.should_not be_true
  end

  test 'users should have an instance of TOTP/ROTP objects' do
    u = User.first
    (u.time_based_otp.is_a? ROTP::TOTP).should_not be_false
    (u.recovery_otp.is_a? ROTP::HOTP).should_not be_false
  end

  test 'users should have their otp_auth_secret/persistence_seed set on creation' do
    User.first.otp_auth_secret.should_not be_false
    User.first.otp_persistence_seed.should_not be_false
  end

  test 'reset_otp_credentials should generate new secrets and disable OTP' do
    u = User.first
    u.update_attribute(:otp_enabled, true)
    u.otp_enabled.should_not be_false
    otp_auth_secret = u.otp_auth_secret
    otp_persistence_seed = u.otp_persistence_seed

    u.reset_otp_credentials!
    (otp_auth_secret == u.otp_auth_secret).should_not be_true
    (otp_persistence_seed == u.otp_persistence_seed).should_not be_true
    u.otp_enabled.should_not be_true
  end

  test 'reset_otp_persistence should generate new persistence_seed but NOT change the otp_auth_secret' do
    u = User.first
    u.update_attribute(:otp_enabled, true)
    u.otp_enabled.should_not be_false
    otp_auth_secret = u.otp_auth_secret
    otp_persistence_seed = u.otp_persistence_seed

    u.reset_otp_persistence!
    ((otp_auth_secret == u.otp_auth_secret)).should_not be_false
    (otp_persistence_seed == u.otp_persistence_seed).should_not be_true
    u.otp_enabled.should_not be_false
  end

  test 'generating a challenge, should retrieve the user later' do
    u = User.first
    u.update_attribute(:otp_enabled, true)
    challenge = u.generate_otp_challenge!

    w = User.find_valid_otp_challenge(challenge)
    (w.is_a? User).should_not be_false
    u.should == w
  end

  test 'expiring the challenge, should retrieve nothing' do
    u = User.first
    u.update_attribute(:otp_enabled, true)
    challenge = u.generate_otp_challenge!(1.second)
    sleep(2)

    w = User.find_valid_otp_challenge(challenge)
    w.should be_nil
  end

  test 'expired challenges should not be valid' do
    u = User.first
    u.update_attribute(:otp_enabled, true)
    challenge = u.generate_otp_challenge!(1.second)
    sleep(2)
    u.otp_challenge_valid?.should == false
  end

  test 'null otp challenge' do
    u = User.first
    u.update_attribute(:otp_enabled, true)
    u.validate_otp_token('').should == false
    u.validate_otp_token(nil).should == false
  end

  test 'generated otp token should be valid for the user' do
    u = User.first
    u.update_attribute(:otp_enabled, true)

    secret = u.otp_auth_secret
    token = ROTP::TOTP.new(secret).now

    u.validate_otp_token(token).should == true
  end

  test 'generated otp token, out of drift window, should be NOT valid for the user' do
    u = User.first
    u.update_attribute(:otp_enabled, true)

    secret = u.otp_auth_secret

    [3.minutes.from_now, 3.minutes.ago].each do |time|
      token = ROTP::TOTP.new(secret).at(time)
      u.valid_otp_token?(token).should == false
    end
  end

  test 'recovery secrets should be valid, and valid only once' do
    u = User.first
    u.update_attribute(:otp_enabled, true)
    recovery = u.next_otp_recovery_tokens

    (u.valid_otp_recovery_token? recovery.fetch(0)).should_not be_false
    u.valid_otp_recovery_token?(recovery.fetch(0)).should == false
    (u.valid_otp_recovery_token? recovery.fetch(2)).should_not be_false
  end
end
