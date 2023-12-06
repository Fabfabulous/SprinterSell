Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  resources :contacts
  resources :company, only:%i(index show)
  resources :meetings
  get "map", to: "pages#map"

  get "search_company", to: "companies#search_company"

  resources :notes, only:%i(create)
  # resources :note, only:%i(create)
  patch '/save_note', to: 'pages#save_note'

  require "sidekiq/web"
  authenticate :user, ->(user) { user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

end
