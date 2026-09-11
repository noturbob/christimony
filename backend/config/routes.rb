Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      post "signup", to: "registrations#create"
      post "login", to: "sessions#create"
      post "auth/phone/start", to: "phone_auth#start"
      post "auth/phone/verify", to: "phone_auth#verify"
      get "me", to: "accounts#me"

      get "denominations", to: "denominations#index"
      get "prompt_questions", to: "prompt_questions#index"

      resources :profiles, only: [:index, :show, :create, :update] do
        collection do
          get :feed
        end
        resources :vouches, only: [:index, :create]
        resources :prompts, controller: "profile_prompts", only: [:index, :create, :update, :destroy]
        resources :photos, controller: "profile_photos", only: [:create, :destroy] do
          collection do
            patch :reorder
          end
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
      resources :subscriptions, only: [:index, :create]
    end
  end
end
