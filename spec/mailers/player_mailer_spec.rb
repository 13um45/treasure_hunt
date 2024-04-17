require "rails_helper"

RSpec.describe PlayerMailer, type: :mailer do
  describe 'send_temporary_token' do
    let(:token) { '1234567890' }
    let(:mail) { PlayerMailer.send_temporary_token('user@example.com', token) }

    it 'renders the headers' do
      expect(mail.subject).to eq('Your Temporary Token')
      expect(mail.to).to eq(['user@example.com'])
      expect(mail.from).to eq(['noreply@example.com'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match(token)
    end
  end

  describe 'send_winner_confirmation' do
    let(:mail) { PlayerMailer.send_winner_confirmation('winner@example.com') }

    it 'renders the headers' do
      expect(mail.subject).to eq('You found the treasure!')
      expect(mail.to).to eq(['winner@example.com'])
      expect(mail.from).to eq(['noreply@example.com'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match('You found the treasure!')
    end
  end
end
