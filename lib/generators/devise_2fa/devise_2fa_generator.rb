module Devise2fa
  module Generators
    class Devise2faGenerator < Rails::Generators::NamedBase
      namespace 'devise_2fa'

      desc 'Add :two_factorable directive in the given model.'

      def inject_devise_2fa_content
        path = File.join('app', 'models', "#{file_path}.rb")
        inject_into_file(path, 'two_factorable, :', after: 'devise :') if File.exist?(path)
      end

      hook_for :orm
    end
  end
end
