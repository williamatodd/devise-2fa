# frozen_string_literal: true

if defined?(ActiveRecord)
  class User < ApplicationRecord
    devise :two_factorable, :database_authenticatable, :registerable,
      :recoverable, :rememberable, :validatable
  end
else
  require 'mongoid'
  class User
    include Mongoid::Document
    field :otp_auth_secret,                 type: String
    field :otp_recovery_secret,             type: String
    field :otp_enabled,                     type: Boolean, default: false
    field :otp_mandatory,                   type: Boolean, default: false
    field :otp_enabled_on,                  type: DateTime
    field :otp_failed_attempts,             type: Integer, default: 0
    field :otp_recovery_counter,            type: Integer, default: 0
    field :otp_persistence_seed,            type: String
    field :otp_session_challenge,           type: String
    field :otp_challenge_expires,           type: DateTime

    index({ otp_session_challenge: 1 }, background: true)
    index({ otp_challenge_expires: 1 }, background: true)

    devise :two_factorable, :database_authenticatable, :registerable,
      :recoverable, :rememberable, :validatable
    field :email,              type: String, default: ''
    field :encrypted_password, type: String, default: ''
    field :reset_password_token,   type: String
    field :reset_password_sent_at, type: Time
    field :remember_created_at, type: Time
    field :name, type: String
    field :phone, type: String
  end
end
