Twinx::Application.routes.draw do
  resources :counties, only:["index"]
  get '/counties/:id/people', to: 'counties#people', as: 'county'

  devise_for :users

  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  resources :races do
    resources :teams, only:["index","new","create"]
    resources :categories
    resources :participants
    resources :results
    resources :data_transfer, only:["index","create"]
    get 'cup', to: 'cup#index'
  end

  root :to => 'races#index'
end
