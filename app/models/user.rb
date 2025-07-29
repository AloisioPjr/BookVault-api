class User < ApplicationRecord
  has_secure_password # Enables password hashing and authentication

  has_many :loans, dependent: :destroy# Allows users to have multiple loans
  has_many :reservations, dependent: :destroy # Allows users to have multiple reservations

  validates :email, presence: true, uniqueness: true  # Ensures email is present and unique
end
