# spec/requests/api/v1/authentication_spec.rb
require 'rails_helper'

RSpec.describe "Authentication API", type: :request do
  let!(:user) { User.create!(email: "user@bookvault.dev", password: "password123") }

  describe "POST /api/v1/login" do
    it "logs in with valid credentials" do
      post "/api/v1/login", params: { email: user.email, password: "password123" }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["message"]).to eq("Login successful")
    end

    it "fails with invalid credentials" do
      post "/api/v1/login", params: { email: user.email, password: "wrongpass" }

      expect(response).to have_http_status(:unauthorized)
      expect(JSON.parse(response.body)["error"]).to eq("Invalid credentials")
    end
  end
end
# bundle exec rspec spec/requests/api/v1/authentication_spec.rb