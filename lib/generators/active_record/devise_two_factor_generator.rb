require 'rails/generators/active_record'

module ActiveRecord
  module Generators
    class DeviseTwoFactorGenerator < ActiveRecord::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      def copy_devise_migration
        migration_template 'migration.rb', "db/migrate/devise_two_factor_add_to_#{table_name}.rb"
      end

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

      private

      def model_exists?
        File.exist?(File.join(destination_root, model_path))
      end

      def model_path
        @model_path ||= File.join("app", "models", "#{file_path}.rb")
      end
    end
  end
end
