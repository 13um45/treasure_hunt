require 'rails_helper'

RSpec.describe Guess, type: :model do
  describe 'validations' do
    let(:player) { create(:player, email: 'test@example.com') }
    let(:treasure) { create(:treasure, lat: 34.052235, long: -118.243683) }

    context "when a player wins for the first time" do
      it 'is valid for the first winning guess' do
        first_guess = create(:guess, player: player, treasure: treasure, winner: true)
        expect(first_guess).to be_valid
      end
    end

    context "when a player attempts to win a second time" do
      before do
        create(:guess, player: player, treasure: treasure, winner: true)
      end

      it 'is not valid for a second winning guess' do
        second_guess = build(:guess, player: player, treasure: treasure, winner: true)
        expect(second_guess).not_to be_valid
      end

      it 'adds the correct error message to the second guess' do
        second_guess = build(:guess, player: player, treasure: treasure, winner: true)
        second_guess.valid?
        expect(second_guess.errors[:winner]).to include('a player can only win once')
      end
    end
  end
end
