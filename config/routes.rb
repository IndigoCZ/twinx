Twinx::Application.routes.draw do

  resources :people


  resources :counties

  resources :races do
    resources :teams, only:["index"]
    resources :categories
    resources :participants
  end

  root :to => 'front_page#index'

end
