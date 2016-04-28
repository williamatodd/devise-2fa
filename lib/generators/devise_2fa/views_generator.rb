require 'generators/devise/views_generator'

module Devise2fa
  module Generators
    class ViewsGenerator < Rails::Generators::Base
      desc 'Copies all Devise 2FA views to your application.'

      argument :scope, required: false, default: nil,
                       desc: 'The scope to copy views to'

      include ::Devise::Generators::ViewPathTemplates
      source_root File.expand_path('../../../../app/views/devise_2fa', __FILE__)
      def copy_views
        view_directory :credentials, 'app/views/devise_2fa/credentials'
        view_directory :tokens, 'app/views/devise_2fa/tokens'
      end
    end
  end
end
