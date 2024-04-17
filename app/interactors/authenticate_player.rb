class AuthenticatePlayer
  include Interactor

  def call
    token = context.token
    hashed_token = Digest::SHA256.hexdigest(token)
    player = LongLivedToken.find_by(hashed_token: hashed_token)&.player

    if player
      context.player = player
    else
      context.status = :unauthorized
      context.fail!(error: "Unauthorized")
    end
  end
end
