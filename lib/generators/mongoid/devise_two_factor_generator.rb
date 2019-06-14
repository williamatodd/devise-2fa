require 'rails/generators/named_base'
require 'generators/devise/orm_helpers'

module Mongoid
  module Generators
    class DeviseTwoFactorGenerator < Rails::Generators::NamedBase
      include Devise::Generators::OrmHelpers

      def inject_field_types
        inject_into_file model_path, migration_data, after: "include Mongoid::Document\n" if model_exists?
      end

      def migration_data
<<RUBY
  # Devise TwoFactor
  field :encrypted_otp_auth_secret,       type: String, encrypted: true
  field :encrypted_otp_recovery_secret,   type: String, encrypted: true
  field :otp_enabled,                     type: Boolean, default: false
  field :otp_mandatory,                   type: Boolean, default: false
  field :otp_enabled_on,                  type: DateTime
  field :otp_failed_attempts,             type: Integer, default: 0
  field :otp_recovery_counter,            type: Integer, default: 0
  field :otp_persistence_seed,            type: String
  field :otp_session_challenge,           type: String
  field :otp_challenge_expires,           type: DateTime
  field :last_successful_otp_at,          type: DateTime

  index({ otp_session_challenge: 1 }, background: true)
  index({ otp_challenge_expires: 1 }, background: true)

RUBY
      end
    end
  end
end
