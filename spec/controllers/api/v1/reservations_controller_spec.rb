require 'rails_helper'

RSpec.describe Api::V1::ReservationsController, type: :controller do
  let(:user) { User.create(email: 'user@example.com', password: 'password123') }
  let(:admin) { User.create(email: 'admin@example.com', password: 'password123', admin: true) }
  let(:book) { Book.create(title: 'Reserved Book', author: 'Author', isbn: '888', genre: 'Fiction', copies_available: 0) }

  before do
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe 'POST #create' do
    it 'creates a reservation when book has no available copies' do
      post :create, params: { reservation: { book_id: book.id } }
      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)['book_id']).to eq(book.id)
    end

    it 'rejects reservation if book is available' do
      book.update(copies_available: 2)

      post :create, params: { reservation: { book_id: book.id } }
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'rejects duplicate reservation for same book by same user' do
      Reservation.create(user: user, book: book, reserved_at: Time.current)

      post :create, params: { reservation: { book_id: book.id } }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'GET #index' do
    it 'shows user reservations only (non-admin)' do
      Reservation.create(user: user, book: book, reserved_at: Time.current)
      other_user = User.create(email: 'other@example.com', password: 'password123')
      Reservation.create(user: other_user, book: book, reserved_at: Time.current)

      get :index
      result = JSON.parse(response.body)
      expect(result.all? { |r| r['user_id'] == user.id }).to be true
    end
  end

  describe 'DELETE #destroy' do
    it 'allows user to delete their reservation' do
      reservation = Reservation.create(user: user, book: book, reserved_at: Time.current)

      delete :destroy, params: { id: reservation.id }

      expect(response).to have_http_status(:no_content)
      expect(Reservation.exists?(reservation.id)).to be false
    end

    it 'prevents non-owners from deleting others’ reservations' do
      other_user = User.create(email: 'intruder@example.com', password: 'password123')
      reservation = Reservation.create(user: other_user, book: book, reserved_at: Time.current)

      delete :destroy, params: { id: reservation.id }

      expect(response).to have_http_status(:unauthorized)
    end

    it 'allows admin to delete any reservation' do
      allow(controller).to receive(:current_user).and_return(admin)
      reservation = Reservation.create(user: user, book: book, reserved_at: Time.current)

      delete :destroy, params: { id: reservation.id }

      expect(response).to have_http_status(:no_content)
    end
  end
end
# bundle exec rspec spec/controllers/api/v1/reservations_controller_spec.rb