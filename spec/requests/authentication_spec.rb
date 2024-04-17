require 'rails_helper'

RSpec.describe "Authentication", type: :request do
  describe "POST /authenticate" do
    let(:player) { create(:player, email: 'player@example.com') }
    let(:valid_token) { SecureRandom.hex(10) }
    let(:hashed_valid_token) { Digest::SHA256.hexdigest(valid_token) }

    context "with a valid token" do
      before do
        create(:temporary_token, player: player, hashed_token: hashed_valid_token, expiry: 24.hours.from_now, enabled: true)
      end

      it "returns a status of created" do
        post authenticate_path, params: { token: valid_token }
        expect(response).to have_http_status(:created)
      end

      it "issues a long_lived token" do
        expect do
          post authenticate_path, params: { token: valid_token }
        end.to change { LongLivedToken.count }.by(1)
      end

      it "associates the long_lived token with the correct player" do
        post authenticate_path, params: { token: valid_token }
        token = LongLivedToken.find_by(player: player)
        expect(token).not_to be_nil
      end
    end

    context "with an expired token" do
      before do
        create(:temporary_token, player: player, hashed_token: Digest::SHA256.hexdigest('expired'), expiry: 1.hour.ago, enabled: true)
      end

      it "returns an unauthorized status" do
        post authenticate_path, params: { token: 'expired' }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "with an invalid token" do
      it "returns an unauthorized status for non-existent token" do
        post authenticate_path, params: { token: 'nonexistent' }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "with a disabled token" do
      before do
        create(:temporary_token, player: player, hashed_token: Digest::SHA256.hexdigest('disabled'), expiry: 24.hours.from_now, enabled: false)
      end

      it "returns an unauthorized status for disabled token" do
        post authenticate_path, params: { token: 'disabled' }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
