Rails.application.routes.draw do
  get 'password_resets/new'
  get 'password_resets/edit'
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
  
  resources :users do
    member do
      get :following, :followers
    end
  end

  resources :users do
    member do
      get :favorites, :private_cheatsheets, :public_cheatsheets
    end
  end

  resources :cheatsheets,          only: [:new, :create, :destroy, :show, :index]
  resources :tags, only: [:index, :show]
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :relationships,       only: [:create, :destroy]
  resources :favorites,       only: [:create, :destroy]

end
