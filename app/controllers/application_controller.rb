class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Basic::ControllerMethods

  before_action :authenticate_user

  def authenticate_user
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

  def authenticate_admin!
    render json: { error: "Admin access only" }, status: :unauthorized unless current_user&.admin?
  end
end
