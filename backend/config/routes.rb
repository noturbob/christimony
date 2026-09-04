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
    end
  end
end