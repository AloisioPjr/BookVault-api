Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      
      # API versioning
      devise_for :users,
        path: '',
        path_names: {
          sign_in: 'login',
          sign_out: 'logout',
          registration: 'register'
        },
        controllers: {
          sessions: 'api/v1/users/sessions',
          registrations: 'api/v1/users/registrations'
        }

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
