class Book < ApplicationRecord
  has_many :loans, dependent: :destroy  # Allows books to have multiple loans
  has_many :reservations, dependent: :destroy # Allows books to have multiple reservations
  validates :title, :author, :isbn, :genre, :copies_available, presence: true # Ensures these fields are present
end
