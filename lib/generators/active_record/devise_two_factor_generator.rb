# frozen_string_literal: true

require 'rails/generators/active_record'

module ActiveRecord
  module Generators
    class DeviseTwoFactorGenerator < ActiveRecord::Generators::Base
      def inject_field_types
        class_path = if namespaced?
          class_name.to_s.split("::")
        else
          [class_name]
        end

        inject_into_class(model_path, class_path.last, content) if model_exists?
      end

      def content
<<RUBY
  attr_encrypted :otp_auth_secret
  attr_encrypted :otp_recovery_secret
  validates :otp_auth_secret, symmetric_encryption: true
  validates :otp_recovery_secret, symmetric_encryption: true
RUBY
      end

      def model_exists?
        File.exist? "app/models/#{table_name}.rb"
      end
    end
  end
end
