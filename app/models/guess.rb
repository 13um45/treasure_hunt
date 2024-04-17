class Guess < ApplicationRecord
  belongs_to :player
  belongs_to :treasure

  scope :winners, -> { where(winner: true) }

  validate :player_can_only_be_winner_once, if: :winner?

  private

  def player_can_only_be_winner_once
    existing_winners = player.guesses.winners.where.not(id: self.id)

    if existing_winners.exists?
      errors.add(:winner, "a player can only win once")
    end
  end
end
