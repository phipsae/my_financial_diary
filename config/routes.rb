Rails.application.routes.draw do
  get 'price_point/index'
  devise_for :users
  root to: 'landing_page#home'
  get '/dashboard', to: 'dashboard#index'
  resources :asset, only: [ :index, :show, :create, :update, :destroy ]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :articles, :only => [:index, :show]
end
