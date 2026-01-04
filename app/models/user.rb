class User < ApplicationRecord
  has_secure_password

  enum :role, { user: 0, admin: 1 }

  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }
end
