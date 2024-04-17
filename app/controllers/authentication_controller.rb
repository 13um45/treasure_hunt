class AuthenticationController < ApplicationController
  def create
    temporary_token = TemporaryToken.find_by(hashed_token: Digest::SHA256.hexdigest(params[:token]))

    if temporary_token.present? && temporary_token.enabled? && temporary_token.expiry > Time.current
      # Invalidate the temporary token
      temporary_token.update(enabled: false)

      # Create and return a long-lived token
      long_lived_token = create_long_lived_token(temporary_token.player)
      render json: { long_lived_token: long_lived_token }, status: :created
    else
      render json: { error: 'Invalid or expired token' }, status: :unauthorized
    end
  end

  private

  def create_long_lived_token(player)
    token = SecureRandom.hex(20)
    hashed_token = Digest::SHA256.hexdigest(token)
    LongLivedToken.create!(
      player: player,
      hashed_token: hashed_token,
      expiry: 1.year.from_now,
      enabled: true
    )
    token
  end
end
