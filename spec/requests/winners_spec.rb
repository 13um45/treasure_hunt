require 'rails_helper'

RSpec.describe "Winners", type: :request do
  describe "GET /winners" do
    let!(:player) { create(:player, email: 'winner@example.com') }
    let!(:player2) { create(:player, email: 'winner2@example.com') }
    let!(:treasure) { create(:treasure, lat: 34.052235, long: -118.243683) }
    let!(:guesses) {
      [
        create(:guess, player: player, treasure: treasure, distance_from_treasure: 500, winner: true),
        create(:guess, player: player2, treasure: treasure, distance_from_treasure: 300, winner: true)
      ]
    }

    context "when paginating results" do
      before { get winners_path, params: { page: 1, per_page: 1 } }

      it "returns HTTP status OK" do
        expect(response).to have_http_status(:ok)
      end

      it "returns exactly one result" do
        json_response = JSON.parse(response.body)
        expect(json_response.length).to eq(1)
      end
    end

    context "when sorting winners by distance ascending" do
      before { get winners_path, params: { sort_direction: 'asc' } }

      it "returns the closest winner first" do
        json_response = JSON.parse(response.body)
        expect(json_response.first['distance_from_treasure']).to eq(300)
      end
    end

    context "when sorting winners by distance descending" do
      before { get winners_path, params: { sort_direction: 'desc' } }

      it "returns the farthest winner first" do
        json_response = JSON.parse(response.body)
        expect(json_response.first['distance_from_treasure']).to eq(500)
      end
    end
  end
end
