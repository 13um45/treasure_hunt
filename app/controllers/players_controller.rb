class PlayersController < ApplicationController
  def create
    player = Player.find_by(email: player_params[:email])

    if player.present?
      render json: { error: 'Player already exists with this email' }, status: :unprocessable_entity
    else
      @player = Player.new(player_params)

      if @player.save
        temporary_token = generate_temporary_token(@player)
        PlayerMailer.send_temporary_token(@player.email, temporary_token).deliver_later

        render json: { message: "Player created check email for temporary token" }, status: :created
      else
        render json: @player.errors, status: :unprocessable_entity
      end
    end
  end

  private

  def player_params
    params.require(:player).permit(:email)
  end

  def generate_temporary_token(player)
    token = SecureRandom.hex(10)
    TemporaryToken.create!(
      player: player,
      hashed_token: Digest::SHA256.hexdigest(token),
      expiry: 24.hours.from_now,
      enabled: true
    )
    token
  end
end
