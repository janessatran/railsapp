Rails.application.routes.draw do
  root 'static_pages#home'

  get 'cheatsheets/new'
  get 'cheatsheets/show'

  get '/search' => 'static_pages#search', :as => 'search_page'
  get '/signup' => 'users#new', :as => 'signup'
  post '/signup',  to: 'users#create'

  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  resources :users


end
