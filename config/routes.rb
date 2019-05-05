Rails.application.routes.draw do
  root 'static_pages#home'
  get '/search' => 'static_pages#search', :as => 'search_page'
  get '/signup' => 'users#new', :as => 'signup'
  resources :users
  post '/signup',  to: 'users#create'

end
