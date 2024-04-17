require 'rails_helper'

RSpec.describe "Guesses", type: :request do
  describe "POST /guesses" do
    let(:player) { create(:player, email: 'player@example.com') }
    let(:token) { 'token' }
    let(:hashed_token) { Digest::SHA256.hexdigest(token) }
    let!(:treasure) { create(:treasure, lat: 34.052235, long: -118.243683, found: false) }

    before do
      create(:long_lived_token, player: player, hashed_token: hashed_token, expiry: 1.year.from_now, enabled: true)
    end

    let(:headers) { { 'Authorization' => "Bearer #{token}" } }

    context "when unauthorized" do
      let(:headers) { { 'Authorization' => "Bearer invalid_token" } }
      let(:params) { { guess: { lat: '34.0522', long: '-118.2437' } } }

      it "returns an unauthorized status" do
        post guesses_path, params: params, headers: headers
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "when no treasures are available" do
      before { Treasure.update_all(found: true) }
      let(:params) { { guess: { lat: '34.0522', long: '-118.2437' } } }

      it "returns an error indicating no available treasures" do
        post guesses_path, params: params, headers: headers
        expect(response.body).to include('No treasures available')
      end
    end

    context "when the guess is close enough to the treasure" do
      let(:params) { { guess: { lat: '34.0522', long: '-118.2437' } } }

      before do
        VCR.use_cassette('close_enough_guess') do
          post guesses_path, params: params, headers: headers
        end
      end

      it "returns a status of 200 OK" do
        expect(response).to have_http_status(:ok)
      end

      it "includes a congratulatory message in the response body" do
        expect(response.body).to include('Congratulations')
      end

      it "marks the treasure as found" do
        expect(treasure.reload.found).to be(true)
      end

      it "creates a guess record for the player" do
        expect(player.guesses.count).to eq(1)
      end

      it "marks the player's last guess as a winner" do
        expect(player.guesses.last.winner).to be(true)
      end
    end

    context "when the guess is too far from the treasure" do
      let(:params) { { guess: { lat: '35.0522', long: '-119.2437' } } }

      before do
        VCR.use_cassette('too_far_guess') do
          post guesses_path, params: params, headers: headers
        end
      end

      it "returns a status of 200 OK" do
        expect(response).to have_http_status(:ok)
      end

      it "includes a message to try again in the response body" do
        expect(response.body).to include('Try again')
      end

      it "does not mark the treasure as found" do
        expect(treasure.reload.found).to be(false)
      end

      it "creates a guess record for the player" do
        expect(player.guesses.count).to eq(1)
      end

      it "does not mark the player's last guess as a winner" do
        expect(player.guesses.last.winner).to be(false)
      end
    end
  end
end
