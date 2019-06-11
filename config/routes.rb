# frozen_string_literal: true

Rails.application.routes.draw do
  resources :volvos
  resources :accounts
  root 'accounts#index'
end
