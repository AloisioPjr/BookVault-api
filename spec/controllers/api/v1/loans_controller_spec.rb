
require 'rails_helper'

RSpec.describe Api::V1::LoansController, type: :controller do
  let(:user) { User.create(email: 'user@example.com', password: 'password123') }
  let(:admin) { User.create(email: 'admin@example.com', password: 'password123', admin: true) }
  let(:book) { Book.create(title: 'Loan Book', author: 'Author', isbn: '777', genre: 'Action', copies_available: 2) }

  before do
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe 'POST #create' do
    it 'creates a loan when book is available and not already borrowed' do
      post :create, params: { loan: { book_id: book.id } }
      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)['book_id']).to eq(book.id)
    end

    it 'rejects borrowing if no copies are available' do
      book.update(copies_available: 0)

      post :create, params: { loan: { book_id: book.id } }
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'rejects if user already borrowed the book' do
      Loan.create(user: user, book: book, borrowed_at: Time.current)

      post :create, params: { loan: { book_id: book.id } }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'PATCH #return' do
    it 'marks loan as returned and increases book copies' do
      loan = Loan.create(user: user, book: book, borrowed_at: Time.current)

      patch :return, params: { id: loan.id }

      expect(response).to have_http_status(:ok)
      expect(loan.reload.returned_at).not_to be_nil
      expect(book.reload.copies_available).to eq(3)
    end

    it 'fails if book already returned' do
      loan = Loan.create(user: user, book: book, borrowed_at: Time.current, returned_at: Time.current)

      patch :return, params: { id: loan.id }

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
# bundle exec rspec spec/controllers/api/v1/loans_controller_spec.rb