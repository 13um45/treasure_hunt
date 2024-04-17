require 'rails_helper'

RSpec.describe "Players", type: :request do
  describe "POST /players" do
    let(:valid_attributes) { { email: 'newplayer@example.com' } }
    let(:invalid_attributes) { { email: '' } }
    let(:duplicate_attributes) { { email: 'existingplayer@example.com' } }

    context "when the request is valid" do
      it 'creates a new Player' do
        expect do
          post players_path, params: { player: valid_attributes }
        end.to change(Player, :count).by(1)
      end

      it "returns a reponse with the http status of created" do
        post players_path, params: { player: valid_attributes }

        expect(response).to have_http_status(:created)
      end

      it "returns a reponse body with a message" do
        post players_path, params: { player: valid_attributes }

        expect(response.body).to match(/Player created check email for temporary token/)
      end

      it 'sends a temporary token to the player' do
        allow(PlayerMailer).to receive_message_chain(:send_temporary_token, :deliver_later)

        post players_path, params: { player: valid_attributes }

        expect(PlayerMailer).to have_received(:send_temporary_token).with('newplayer@example.com', anything)
      end
    end

    context "when the email already exists" do
      before do
        create(:player, duplicate_attributes)
      end

      it 'does not create a new player' do
        expect do
          post players_path, params: { player: duplicate_attributes }
        end.not_to change(Player, :count)
      end

      it 'returns a response with the http status of unprocessable_entity' do
        post players_path, params: { player: duplicate_attributes }

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns a response body with a message' do
        post players_path, params: { player: duplicate_attributes }

        expect(response.body).to match(/Player already exists with this email/)
      end
    end

    context "when the request is invalid" do
      it 'does not create a player' do
        expect {
          post players_path, params: { player: invalid_attributes }
        }.not_to change(Player, :count)
      end

      it 'returns a response with the http status of unprocessable_entity' do
        post players_path, params: { player: invalid_attributes }

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
