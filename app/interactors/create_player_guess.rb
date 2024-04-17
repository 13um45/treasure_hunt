class CreatePlayerGuess
  include Interactor
  WINNING_GUESS_THRESHOLD_IN_METERS = 1000

  def call
    guess = context.player.guesses.create(
      treasure: context.treasure,
      lat: context.lat,
      long: context.long,
      distance_from_treasure: context.distance,
      winner: context.distance < WINNING_GUESS_THRESHOLD_IN_METERS
    )

    if guess.blank?
      context.status = :unprocessable_entity
      context.fail!(error: "Failed to create guess")
    end

    context.guess = guess

    if guess.winner?
      context.treasure.update!(found: true)
      context.message = "Congratulations! You have found the treasure!"
    else
      context.message = "Try again! You are too far from any treasure."
    end
  end
end
