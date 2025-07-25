class Api::V1::RegistrationsController < ApplicationController
  # Skip authentication check for registration
  skip_before_action :authenticate_user

  # POST /register
  # Handles user account creation
  def create
    user = User.new(registration_params)

    # Attempt to save the new user
    if user.save
      render json: { message: 'Registration successful', user_id: user.id }, status: :created
    else
      # Return validation errors to the client
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  # Strong parameters: only allow permitted user fields
  def registration_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
