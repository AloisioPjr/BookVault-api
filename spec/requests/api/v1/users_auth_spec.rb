require 'rails_helper'

RSpec.describe 'User Registration and Login', type: :request do
  let(:valid_user) do
    {
      user: {
        email: 'user@example.com',
        password: 'password123',
        password_confirmation: 'password123'
      }
    }
  end

  let(:json_headers) do
    {
      'ACCEPT' => 'application/json',
      'CONTENT_TYPE' => 'application/json'
    }
  end

  describe 'POST /api/v1/register' do
    it 'registers a user with valid details' do
      post '/api/v1/register', params: valid_user.to_json, headers: json_headers

      expect(response).to have_http_status(:created)
      body = JSON.parse(response.body)
      expect(body['data']['email']).to eq('user@example.com')
    end

    it 'fails to register with missing email' do
      invalid_params = valid_user.deep_dup
      invalid_params[:user][:email] = nil

      post '/api/v1/register', params: invalid_params.to_json, headers: json_headers

      expect(response).to have_http_status(:unprocessable_entity)
      body = JSON.parse(response.body)
      expect(body['status']['message']).to include("can't be blank")
    end

    it 'fails with mismatched passwords' do
      invalid_params = valid_user.deep_dup
      invalid_params[:user][:password_confirmation] = 'wrongpass'

      post '/api/v1/register', params: invalid_params.to_json, headers: json_headers

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'POST /api/v1/login' do
    before do
      User.create!(
        email: 'user@example.com',
        password: 'password123',
        password_confirmation: 'password123'
      )
    end

    it 'logs in with valid credentials and establishes session' do
      post '/api/v1/login',
           params: {
             user: {
               email: 'user@example.com',
               password: 'password123'
             }
           }.to_json,
           headers: json_headers

      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body['data']['email']).to eq('user@example.com')
    end

    it 'fails with invalid password' do
      post '/api/v1/login',
           params: {
             user: {
               email: 'user@example.com',
               password: 'wrongpass'
             }
           }.to_json,
           headers: json_headers

      expect(response).to have_http_status(:unauthorized)
      body = JSON.parse(response.body)
      expect(body['status']['message']).to eq('Invalid email or password.')
    end

    it 'fails with non-existent user' do
      post '/api/v1/login',
           params: {
             user: {
               email: 'nonexistent@example.com',
               password: 'whatever'
             }
           }.to_json,
           headers: json_headers

      expect(response).to have_http_status(:unauthorized)
    end
  end
end
 #  bundle exec rspec spec/requests/api/v1/users_auth_spec.rb
