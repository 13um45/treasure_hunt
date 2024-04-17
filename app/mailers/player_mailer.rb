class PlayerMailer < ApplicationMailer
  default from: 'noreply@example.com'

  def send_temporary_token(email, token)
    @token = token
    mail(to: email, subject: 'Your Temporary Token')
  end

  def send_winner_confirmation(email)
    mail(to: email, subject: 'You found the treasure!')
  end
end
