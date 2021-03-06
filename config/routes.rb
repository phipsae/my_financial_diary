Rails.application.routes.draw do
  devise_for :users
  get 'asset_kind/overview'
  root to: 'landing_page#home'
  get '/dashboard', to: 'dashboards#index'
  resources :assets do
    resources :price_points, only: [ :create, :update, :edit ]
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :articles, only: [ :index, :show ]
  resources :price_points, only: [ :index, :destroy, :show ]
end
