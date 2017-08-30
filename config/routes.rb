Rails.application.routes.draw do

  get 'sessions/new'

  resources :users

  resources :account_activations, only:[:edit]

  resources :password_resets,     only: [:new, :create, :edit, :update]

  resources :microposts, only:[:create, :destroy]

  root 'static_pages#home'

  get '/help', to: 'static_pages#help'

  get '/about', to:'static_pages#about'

  get '/contact', to:'static_pages#contact'

  get '/signup', to: 'users#new'

  post '/signup',  to: 'users#create'

  # path about login
  get '/login', to: 'sessions#new'

  post '/login', to: 'sessions#create'

  delete '/logout', to: 'sessions#destroy'



end
