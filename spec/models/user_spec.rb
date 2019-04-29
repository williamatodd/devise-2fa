# frozen_string_literal: true

require 'spec_helper'

RSpec.describe User, type: :model do
  subject (:user) { User.new(email: 'mb@geemail.com', password: 'iwantabigmac1') }
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
      subject(:user) { User.new(email: 'mb@geemail.com')}

      it 'is required' do
        expect(user).to be_invalid
      end
    end
  end
end
