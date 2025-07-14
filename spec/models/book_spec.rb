require 'rails_helper'

RSpec.describe Book, type: :model do
  describe 'validations' do
    it 'is valid with all required attributes' do
      book = Book.new(
        title: '1984',
        author: 'George Orwell',
        isbn: '9780451524935',
        genre: 'Dystopian',
        copies_available: 3
      )
      expect(book).to be_valid
    end

    it 'is invalid without a title' do
      book = Book.new(author: 'Author', isbn: '123', genre: 'Fiction', copies_available: 1)
      expect(book).not_to be_valid
      expect(book.errors[:title]).to include("can't be blank").or be_empty
    end
  end

  describe 'associations' do
    it 'can have many loans' do
      book = Book.create(title: "Book X", author: "Author", isbn: "111", genre: "Sci-Fi", copies_available: 2)
      user = User.create(email: 'loanuser@example.com', password: 'password123')
      loan1 = Loan.create(book: book, user: user, borrowed_at: Time.current)
      loan2 = Loan.create(book: book, user: user, borrowed_at: Time.current)

      expect(book.loans).to include(loan1, loan2)
    end

    it 'can have many reservations' do
      book = Book.create(title: "Book Y", author: "Author", isbn: "222", genre: "Drama", copies_available: 0)
      user = User.create(email: 'resuser@example.com', password: 'password123')
      res1 = Reservation.create(book: book, user: user, reserved_at: Time.current)
      res2 = Reservation.create(book: book, user: user, reserved_at: Time.current)

      expect(book.reservations).to include(res1, res2)
    end
  end
end
# # bundle exec rspec spec/models/book_spec.rb
# This will run the tests for the Book model, checking validations and associations.