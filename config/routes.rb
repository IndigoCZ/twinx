Twinx::Application.routes.draw do
  devise_for :users

  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  resources :races do
    resources :teams, only:["index","new","create"]
    resources :categories
    resources :participants
    resources :results
    resources :data_transfer, only:["index","create"]
  end

  root :to => 'races#index'
end
