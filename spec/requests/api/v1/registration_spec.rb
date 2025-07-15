# spec/requests/api/v1/registration_spec.rb
require 'rails_helper'

RSpec.describe "Registration API", type: :request do
  it "registers a new user" do
    post "/api/v1/register", params: {
      user: { email: "newuser@example.com", password: "securepass", password_confirmation: "securepass" }
    }

    expect(response).to have_http_status(:success).or have_http_status(:created)
    expect(User.exists?(email: "newuser@example.com")).to be_truthy
  end

  it "fails to register if email is taken" do
    User.create!(email: "newuser@example.com", password: "abc123")

    post "/api/v1/register", params: {
      user: { email: "newuser@example.com", password: "abc123", password_confirmation: "abc123" }
    }

    expect(response).to have_http_status(:unprocessable_entity)
  end
end
# bundle exec rspec spec/requests/api/v1/registration_spec.rb