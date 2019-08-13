# frozen_string_literal: true

require 'spec_helper'

RSpec.describe User, type: :model do
  subject(:user) { User.create(email: 'mb@geemail.com', password: 'iwantabigmac1') }
  it 'is valid' do
    expect(user).to be_valid
  end

  describe '#associations' do
    it { is_expected.to respond_to(:email) }
    it { is_expected.to respond_to(:encrypted_password) }
  end

  describe 'validations' do
    describe '#email' do
      subject(:user) { User.new(password: 'iwantabigmac1') }

      it 'is required' do
        expect(user).to be_invalid
      end
    end

    describe '#password' do
      subject(:user) { User.new(email: 'mb@geemail.com') }

      it 'is required' do
        expect(user).to be_invalid
      end
    end
  end

  describe '#validate_otp_token' do
    context 'when otp_drift_window is 3 minutes (default)' do
      let(:user_rotp) { ROTP::TOTP.new(user.otp_auth_secret) }
      let(:control_time) { Time.now }
      let(:token_time) { control_time }

      before do
        Devise.otp_drift_window = 3
        allow(Time).to receive(:now).and_return(control_time)
      end

      context "when token's time is 2 minutes before current time" do
        let(:token_time) { control_time - 2.minutes }

        it do
          expect(user.validate_otp_token(user_rotp.at(token_time))).to be_falsey
        end
      end

      context "when token's time is 1 minute before current time" do
        let(:token_time) { control_time - 1.minute }

        it do
          expect(user.validate_otp_token(user_rotp.at(token_time))).to be_truthy
        end
      end

      context "when token's time is 1 minute after current time" do
        let(:token_time) { control_time + 1.minute }

        it do
          expect(user.validate_otp_token(user_rotp.at(token_time))).to be_truthy
        end
      end

      context "when token's time is 2 minutes after current time" do
        let(:token_time) { control_time + 2.minute }

        it do
          expect(user.validate_otp_token(user_rotp.at(token_time))).to be_falsey
        end
      end
    end
  end
end
