Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      
      # API versioning
      post 'login', to: 'authentication#login'
      post 'register', to: 'registrations#create'

      resources :books
      resources :loans do
        member do
          patch :return
        end
      end
      resources :reservations
    end
  end

  # Health check route
  get "up" => "rails/health#show", as: :rails_health_check
end
