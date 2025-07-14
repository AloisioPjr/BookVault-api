require 'rails_helper'

RSpec.describe Loan, type: :model do
  describe 'associations' do
    it 'belongs to a user' do
      user = User.create(email: 'loanuser@example.com', password: 'password123')
      book = Book.create(title: 'Loanable Book', author: 'Author', isbn: '111', genre: 'Action', copies_available: 1)

      loan = Loan.new(user: user, book: book, borrowed_at: Time.current)

      expect(loan.user).to eq(user)
    end

    it 'belongs to a book' do
      user = User.create(email: 'loanbook@example.com', password: 'password123')
      book = Book.create(title: 'Some Book', author: 'Someone', isbn: '222', genre: 'Mystery', copies_available: 2)

      loan = Loan.new(user: user, book: book, borrowed_at: Time.current)

      expect(loan.book).to eq(book)
    end
  end

  describe 'validations and behavior' do
    it 'is valid with user, book, and borrowed_at' do
      user = User.create(email: 'valid@example.com', password: 'password123')
      book = Book.create(title: 'Valid Book', author: 'Author', isbn: '333', genre: 'Horror', copies_available: 1)

      loan = Loan.new(user: user, book: book, borrowed_at: Time.current)

      expect(loan).to be_valid
    end
  end
end
# # bundle exec rspec spec/models/loan_spec.rb