# spec/requests/api/v1/reservations_spec.rb
require 'rails_helper'

RSpec.describe "Reservations API", type: :request do
  let(:user)  { User.create!(email: "user@bookvault.dev", password: "password123") }
  let(:admin) { User.create!(email: "admin@bookvault.dev", password: "password123", admin: true) }

  let(:book) do
    Book.create!(
      title: "Unavailable Book", author: "Test Author", isbn: "999888777", genre: "Fiction", copies_available: 0
    )
  end

  let(:user_headers) { basic_auth_header(user.email, "password123") }
  let(:admin_headers) { basic_auth_header(admin.email, "password123") }

  describe "POST /api/v1/reservations" do
    it "allows a user to reserve an unavailable book" do
      post "/api/v1/reservations", params: { reservation: { book_id: book.id } }, headers: user_headers

      expect(response).to have_http_status(:created)
      expect(Reservation.count).to eq(1)
      expect(JSON.parse(response.body)["book_id"]).to eq(book.id)
    end

    it "prevents duplicate reservations by the same user" do
      Reservation.create!(user: user, book: book, reserved_at: Time.current)

      post "/api/v1/reservations", params: { reservation: { book_id: book.id } }, headers: user_headers

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)["error"]).to include("already reserved")
    end
  end

  describe "DELETE /api/v1/reservations/:id" do
    let!(:reservation) { Reservation.create!(user: user, book: book, reserved_at: Time.current) }

    it "allows the user to delete their own reservation" do
      delete "/api/v1/reservations/#{reservation.id}", headers: user_headers

      expect(response).to have_http_status(:no_content)
      expect(Reservation.exists?(reservation.id)).to be_falsey
    end

    it "allows the admin to delete any reservation" do
      delete "/api/v1/reservations/#{reservation.id}", headers: admin_headers

      expect(response).to have_http_status(:no_content)
    end
  end
end
