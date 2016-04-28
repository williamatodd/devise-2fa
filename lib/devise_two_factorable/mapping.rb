module DeviseTwoFactorable
  module Mapping
    private

    def default_controllers(options)
      options[:controllers] ||= {}
      options[:controllers][:tokens]      ||= 'devise/tokens'
      options[:controllers][:credentials] ||= 'devise/credentials'
      super
    end
  end
end
