class Player < ApplicationRecord
  validates :email, presence: true
  has_many :guesses
  has_many :temporary_tokens
  has_many :long_lived_tokens
end
