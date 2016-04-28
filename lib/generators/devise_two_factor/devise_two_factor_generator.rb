module DeviseTwoFactor
  module Generators
    class DeviseTwoFactorGenerator < Rails::Generators::NamedBase
      namespace 'devise_two_factor'

      desc 'Add :two_factorable directive in the given model.'

      def inject_devise_two_factor_content
        path = File.join('app', 'models', "#{file_path}.rb")
        inject_into_file(path, 'two_factorable, :', after: 'devise :') if File.exist?(path)
      end

      hook_for :orm
    end
  end
end
