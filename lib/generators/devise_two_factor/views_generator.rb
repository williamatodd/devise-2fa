require 'generators/devise/views_generator'

module DeviseTwoFactor
  module Generators
    class ViewsGenerator < Rails::Generators::Base
      desc 'Copies all Devise TwoFactor views to your application.'

      argument :scope, required: false, default: nil,
                       desc: 'The scope to copy views to'

      include ::Devise::Generators::ViewPathTemplates
      source_root File.expand_path('../../../../app/views/devise_two_factor', __FILE__)
      def copy_views
        view_directory :credentials, 'app/views/devise_two_factor/credentials'
        view_directory :tokens, 'app/views/devise_two_factor/tokens'
      end
    end
  end
end
