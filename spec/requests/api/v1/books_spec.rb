# spec/requests/api/v1/books_spec.rb
require 'rails_helper'

RSpec.describe "Books API", type: :request do
  let(:admin) { User.create!(email: "admin@bookvault.dev", password: "password123", admin: true) }
  let(:user)  { User.create!(email: "user@bookvault.dev", password: "password123", admin: false) }
  let(:book_attrs) do
    {
      title: "RSpec for Rails",
      author: "Test Author",
      isbn: "1234567890",
      genre: "Tech",
      copies_available: 3
    }
  end

  describe "GET /api/v1/books" do
    before do
      Book.create!(book_attrs)
    end

    it "returns all books for authenticated user" do
      get "/api/v1/books", headers: basic_auth_header(user.email, "password123")

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).first["title"]).to eq("RSpec for Rails")
    end
  end

  describe "POST /api/v1/books" do
    it "allows admin to create a book" do
      post "/api/v1/books", params: { book: book_attrs }, headers: basic_auth_header(admin.email, "password123")

      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)["title"]).to eq("RSpec for Rails")
    end

    it "prevents regular user from creating a book" do
      post "/api/v1/books", params: { book: book_attrs }, headers: basic_auth_header(user.email, "password123")

      expect(response).to have_http_status(:unauthorized)
    end
  end
end
# bundle exec rspec spec/requests/api/v1/books_spec.rb