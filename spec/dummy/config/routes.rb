# frozen_string_literal: true

require_relative Rails.root.join('app/models/user')


Rails.application.routes.draw do
  devise_for :users
  root to: 'application#show'
end
