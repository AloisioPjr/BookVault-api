require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it 'is valid with valid email and password' do
      user = User.new(email: 'test@example.com', password: 'password123', password_confirmation: 'password123')
      expect(user).to be_valid
    end

    it 'is invalid without an email' do
      user = User.new(email: nil, password: 'password123')
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("can't be blank")
    end

    it 'is invalid with a short password' do
      user = User.new(email: 'test@example.com', password: '123')
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include("is too short (minimum is 6 characters)")
    end
  end

  describe 'associations' do
    it 'can have many loans' do
      user = User.create(email: 'loans@example.com', password: 'password123')
      book = Book.create(title: "Test Book", author: "Author", isbn: "123", genre: "Fiction", copies_available: 1)
      loan1 = Loan.create(user: user, book: book, borrowed_at: Time.current)
      loan2 = Loan.create(user: user, book: book, borrowed_at: Time.current)

      expect(user.loans).to include(loan1, loan2)
    end

    it 'can have many reservations' do
      user = User.create(email: 'res@example.com', password: 'password123')
      book = Book.create(title: "Book B", author: "Author", isbn: "456", genre: "Drama", copies_available: 0)
      res1 = Reservation.create(user: user, book: book, reserved_at: Time.current)
      res2 = Reservation.create(user: user, book: book, reserved_at: Time.current)

      expect(user.reservations).to include(res1, res2)
    end
  end
end
# # bundle exec rspec spec/models/user_spec.rb
# This will run the tests for the User model, checking validations and associations.