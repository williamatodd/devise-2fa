module DeviseTwoFactorable
  module Controllers
    module UrlHelpers
      def recovery_token_for(resource_or_scope, opts = {})
        scope = Devise::Mapping.find_scope!(resource_or_scope)
        send("recovery_#{scope}_token_path", opts)
      end

      def refresh_credential_path_for(resource_or_scope, opts = {})
        scope = Devise::Mapping.find_scope!(resource_or_scope)
        send("refresh_#{scope}_credential_path", opts)
      end

      def persistence_token_path_for(resource_or_scope, opts = {})
        scope = Devise::Mapping.find_scope!(resource_or_scope)
        send("persistence_#{scope}_token_path", opts)
      end

      def token_path_for(resource_or_scope, opts = {})
        scope = Devise::Mapping.find_scope!(resource_or_scope)
        send("#{scope}_token_path", opts)
      end

      def credential_path_for(resource_or_scope, opts = {})
        scope = Devise::Mapping.find_scope!(resource_or_scope)
        send("#{scope}_credential_path", opts)
      end
    end
  end
end
