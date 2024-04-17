class PlayGame
  include Interactor::Organizer

  organize AuthenticatePlayer, CalculateDistance, CreatePlayerGuess, EmailWinner
end
