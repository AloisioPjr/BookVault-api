class Loan < ApplicationRecord
  belongs_to :user  # Each loan is associated with a user
  belongs_to :book  # Each loan is associated with a book
end
