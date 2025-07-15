class Api::V1::AuthenticationController < ApplicationController
  skip_before_action :authenticate_user

  def login
   

    email = params[:email] || params.dig(:user, :email)
    password = params[:password] || params.dig(:user, :password)

    user = User.find_by(email: email)
    if user&.authenticate(password)
      render json: { message: "Login successful", user_id: user.id }, status: :ok
    else
      render json: { error: "Invalid credentials" }, status: :unauthorized
    end
  end
end
