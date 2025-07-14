module Api
  module V1
    module Users
      class RegistrationsController < Devise::RegistrationsController
        respond_to :json

        def create
          Rails.logger.info "REGISTRATION ATTEMPT: #{params[:user]&.slice(:email)}"

          begin
            user = User.new(sign_up_params)

            if user.save
              sign_up(resource_name, user) # Sign in and establish session
              render json: {
                status: { code: 201, message: 'Signed up successfully.' },
                data: user
              }, status: :created
            else
              Rails.logger.warn "REGISTRATION FAILED for #{params[:user]&.[](:email)}: #{user.errors.full_messages.to_sentence}"
              render json: {
                status: { code: 422, message: user.errors.full_messages.to_sentence }
              }, status: :unprocessable_entity
            end
          rescue => e
            Rails.logger.error "REGISTRATION ERROR for #{params[:user]&.[](:email)}: #{e.class} - #{e.message}"
            render json: {
              status: { code: 500, message: 'Registration failed due to an internal error.' }
            }, status: :internal_server_error
          end
        end

        private

        def sign_up_params
          params.require(:user).permit(:email, :password, :password_confirmation)
        end
      end
    end
  end
end
