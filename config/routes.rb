Twinx::Application.routes.draw do
  resources :people
  resources :counties

  resources :races do
    resources :teams, only:["index"]
    resources :categories
    resources :participants
    resources :results
    resources :data_transfer, only:["index","create"]
  end

  root :to => 'races#index'
end
