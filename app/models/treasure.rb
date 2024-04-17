class Treasure < ApplicationRecord
  has_many :guesses
  has_many :players, through: :guesses
end
