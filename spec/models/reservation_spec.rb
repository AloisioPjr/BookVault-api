require 'rails_helper'

RSpec.describe Reservation, type: :model do
  describe 'associations' do
    it 'belongs to a user' do
      user = User.create(email: 'resuser@example.com', password: 'password123')
      book = Book.create(title: 'Reserved Book', author: 'Author', isbn: '444', genre: 'Fantasy', copies_available: 0)

      reservation = Reservation.new(user: user, book: book, reserved_at: Time.current)

      expect(reservation.user).to eq(user)
    end

    it 'belongs to a book' do
      user = User.create(email: 'reader@example.com', password: 'password123')
      book = Book.create(title: 'Another Book', author: 'Someone', isbn: '555', genre: 'History', copies_available: 0)

      reservation = Reservation.new(user: user, book: book, reserved_at: Time.current)

      expect(reservation.book).to eq(book)
    end
  end

  describe 'validations and logic' do
    it 'is valid with user, book, and reserved_at' do
      user = User.create(email: 'validres@example.com', password: 'password123')
      book = Book.create(title: 'Valid Reservation Book', author: 'Author', isbn: '666', genre: 'Adventure', copies_available: 0)

      reservation = Reservation.new(user: user, book: book, reserved_at: Time.current)

      expect(reservation).to be_valid
    end
  end
end
# bundle exec rspec spec/models/reservation_spec.rb