# spec/requests/api/v1/loans_spec.rb
require 'rails_helper'

RSpec.describe "Loans API", type: :request do
  let(:user) { User.create!(email: "user@bookvault.dev", password: "password123") }
  let(:admin) { User.create!(email: "admin@bookvault.dev", password: "password123", admin: true) }
  let(:book) do
    Book.create!(
      title: "API Design", author: "Jane Doe", isbn: "111222333", genre: "Tech", copies_available: 2
    )
  end

  let(:user_headers) { basic_auth_header(user.email, "password123") }
  let(:admin_headers) { basic_auth_header(admin.email, "password123") }

  describe "POST /api/v1/loans" do
    it "allows a user to borrow an available book" do
      post "/api/v1/loans", params: { loan: { book_id: book.id } }, headers: user_headers

      expect(response).to have_http_status(:created)
      expect(Loan.count).to eq(1)
      expect(book.reload.copies_available).to eq(1)
    end
  end

  describe "PATCH /api/v1/loans/:id/return" do
    let!(:loan) do
      post "/api/v1/loans", params: { loan: { book_id: book.id } }, headers: user_headers
      Loan.last
    end

    it "allows a user to return a book" do
      patch "/api/v1/loans/#{loan.id}/return", headers: user_headers

      expect(response).to have_http_status(:ok)
      expect(loan.reload.returned_at).not_to be_nil
      expect(book.reload.copies_available).to eq(2)
    end
  end
end
