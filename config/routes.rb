Rails.application.routes.draw do
  devise_for :users
  root to: 'landing_page#home'
  get '/dashboard', to: 'dashboard#index'
  resources :asset
end
