class ApplicationController < ActionController::API
  include ActionController::Cookies
  include ActionController::RequestForgeryProtection

  # Use null_session to prevent CSRF errors while keeping protection
  protect_from_forgery with: :null_session

  # Skip CSRF check only for Devise controllers
  skip_before_action :verify_authenticity_token, if: :devise_controller?

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!, unless: :devise_controller?

  protected

  def authenticate_admin!
    unless current_user&.admin?
      render json: { error: "Admin access only" }, status: :unauthorized
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password, :password_confirmation])
    devise_parameter_sanitizer.permit(:sign_in, keys: [:email, :password])
  end
end
