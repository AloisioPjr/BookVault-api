class User < ApplicationRecord
  has_secure_password

  has_many :loans, dependent: :destroy
  has_many :reservations, dependent: :destroy

  validates :email, presence: true, uniqueness: true
end
