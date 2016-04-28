module DeviseTwoFactorable
  module Hooks
    autoload :Sessions, 'devise_two_factorable/hooks/sessions.rb'

    class << self
      def apply
        Devise::SessionsController.send :prepend, Hooks::Sessions
      end
    end
  end
end
