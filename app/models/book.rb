class Book < ApplicationRecord
  has_many :loans, dependent: :destroy
  has_many :reservations, dependent: :destroy
  validates :title, :author, :isbn, :genre, :copies_available, presence: true
end
