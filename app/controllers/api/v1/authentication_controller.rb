class Api::V1::AuthenticationController < ApplicationController
  # Skip authentication for login/logout actions
  skip_before_action :authenticate_user

  # POST /login
  def login
    # Extract email and password from params or nested under :user key
    email = params[:email] || params.dig(:user, :email)
    password = params[:password] || params.dig(:user, :password)

    # Look up the user by email
    user = User.find_by(email: email)

    # Authenticate using has_secure_password
    if user&.authenticate(password)
      render json: { message: "Login successful", user_id: user.id }, status: :ok
    else
      render json: { error: "Invalid credentials" }, status: :unauthorized
    end
  end

  # DELETE /logout
  def logout
    # Basic Auth doesn't use sessions or tokens, so logout is symbolic
    # This endpoint just exists to help the frontend trigger a logout flow
    render json: { message: "Logged out" }, status: :ok
  end
end
