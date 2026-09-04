Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      post "signup", to: "registrations#create"
      post "login", to: "sessions#create"
      get "me", to: "accounts#me"

      resources :profiles, only: [:index, :show, :create, :update] do
        collection do
          get :feed
        end
      end

      resources :interests, only: [:index, :create]
      resources :matches, only: [:index]

      resources :introductions, only: [:index] do
        member do
          post :accept
          post :decline
        end
      end

      resources :conversations, only: [:index, :create] do
        resources :messages, only: [:index, :create]
      end

      resources :verifications, only: [:index, :create]
      resources :profiles do
        resources :vouches, only: [:index, :create]
      end

      resources :subscriptions, only: [:index, :create]
    end
  end
end