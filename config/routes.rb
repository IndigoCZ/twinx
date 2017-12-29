Twinx::Application.routes.draw do
  get 'stats/index'

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
    get 'stats', to: 'stats#index'
    get '/categories/:id/results', to: 'categories#results', as: 'category_results'
  end

  root :to => 'races#index'
end
