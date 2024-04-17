class EmailWinner
  include Interactor

  def call
    if context.guess.winner?
      PlayerMailer.send_winner_confirmation(context.player.email).deliver_later
    end
  end
end
