# spec/support/auth_helper.rb
module AuthHelper
  def basic_auth_header(email, password)
    credentials = ActionController::HttpAuthentication::Basic.encode_credentials(email, password)
    { 'Authorization' => credentials }
  end
end
