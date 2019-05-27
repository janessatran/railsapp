Rails.application.routes.draw do
  root 'static_pages#home'

  get '/new', to: 'cheatsheets#new'


  get '/search' => 'static_pages#search', :as => 'search_page'
  get '/signup' => 'users#new', :as => 'signup'
  post '/signup',  to: 'users#create'

  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

  patch '/users/:id/edit', to: 'users#edit'

  get 'tags/:tag', to: 'cheatsheets#index', as: :tag


  resources :users
  resources :cheatsheets,          only: [:new, :create, :destroy, :show, :index]
  resources :tags, only: [:index, :show]


end
