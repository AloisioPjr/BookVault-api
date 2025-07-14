module Api
  module V1
    module Users
      class SessionsController < Devise::SessionsController
        respond_to :json

        def create
          Rails.logger.info "LOGIN ATTEMPT: #{params[:user]&.slice(:email)}"

          begin
            self.resource = warden.authenticate!(auth_options)
            sign_in(resource_name, resource)

            render json: {
              status: { code: 200, message: 'Logged in successfully.' },
              data: resource
            }, status: :ok
          rescue => e
            Rails.logger.error "LOGIN FAILED for email #{params[:user]&.[](:email)}: #{e.class} - #{e.message}"
            render json: {
              status: { code: 401, message: 'Invalid email or password.' }
            }, status: :unauthorized
          end
        end

        def destroy
          sign_out(current_user)
          render json: {
            status: { code: 200, message: 'Logged out successfully.' }
          }, status: :ok
        end

        private

        def respond_with(resource, _opts = {})
          if resource&.id
            render json: {
              status: { code: 200, message: 'Logged in successfully.' },
              data: resource
            }, status: :ok
          else
            render json: {
              status: { code: 401, message: 'Invalid email or password.' }
            }, status: :unauthorized
          end
        end

        def respond_to_on_destroy
          head :no_content
        end
      end
    end
  end
end
# This code defines a SessionsController for user authentication in a Rails API application.
# It inherits from Devise::SessionsController and provides methods for creating and destroying user sessions.
# The create method handles login attempts, authenticating the user and returning a success message with user data if successful.
# If authentication fails, it logs the error and returns an unauthorized response.
# The destroy method logs out the user and returns a success message.
# The private methods handle JSON responses for successful logins and logouts.
# The controller also includes error handling to log failed login attempts with the user's email.
# This setup is typical for Rails applications using Devise for user authentication, providing a clean API interface for session management.
# The controller is designed to work with JSON requests, making it suitable for API-based applications.
# It uses Rails' built-in logging to track login attempts and errors, which can be useful for debugging and monitoring user authentication activities.