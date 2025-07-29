class Reservation < ApplicationRecord
  belongs_to :user  # Each reservation is associated with a user
  belongs_to :book  # Each reservation is associated with a book
end
