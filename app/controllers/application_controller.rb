class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Basic::ControllerMethods
  before_action :authenticate_user  # Ensure user is authenticated for all actions except registration and login
  def authenticate_user# This method checks if a user is authenticated
    authenticate_or_request_with_http_basic do |email, password|
      user = User.find_by(email: email)
      if user&.authenticate(password)
        @current_user = user
      end
    end
  end
  def current_user
    @current_user
  end
  def authenticate_admin!# This method checks if the current user is an admin
    render json: { error: "Admin access only" }, status: :unauthorized unless current_user&.admin?
  end
end
