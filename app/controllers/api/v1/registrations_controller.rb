class Api::V1::RegistrationsController < ApplicationController
  skip_before_action :authenticate_user

  def create
    user = User.new(registration_params)
    if user.save
      render json: { message: 'Registration successful', user_id: user.id }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def registration_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
