LibraryCollection::Application.routes.draw do
  devise_for :users, path_names: { sign_in: "login", sign_out: "logout" }
  resources :books
  resources :genres
  resources :authors
  resources :keywords
  resources :book_uploads, only: [:new, :create]
  resources :users, only: [ :update, :destroy, :edit, :show, :index ], path: 'manage_users'
  resources :loans, only: [ :show, :index, :new, :create ]

  get 'uploaded_books' => 'book_uploads#uploaded_books'
  get 'search' => 'search#search'
  get 'import' => 'search#import'
  post 'scrape' => 'search#scrape'
  put 'renew' => 'loans#renew'
  put 'return' => 'loans#return'

  get 'admin_dashboard' => 'static_pages#admin_dashboard'
  get 'styleguide' => 'static_pages#styleguide'
  
  root to: 'static_pages#home'
  
end
