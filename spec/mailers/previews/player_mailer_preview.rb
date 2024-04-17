# Preview all emails at http://localhost:3000/rails/mailers/player_mailer
class PlayerMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/player_mailer/send_temporary_token
  def send_temporary_token
    PlayerMailer.send_temporary_token
  end

end
