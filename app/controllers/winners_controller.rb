class WinnersController < ApplicationController
  def index
    @winners = Guess.winners.includes(:player)
                    .order(distance_from_treasure: sort_direction)
                    .page(params[:page])
                    .per(params[:per_page] || 10)

    render json: @winners.map { |guess|
      {
        player_email: guess.player.email,
        distance_from_treasure: guess.distance_from_treasure,
        treasure_id: guess.treasure_id
      }
    }
  end

  private

  # Ensures the sort direction is either 'asc' or 'desc'. Defaults to 'asc' if anything else is provided.
  def sort_direction
    %w[asc desc].include?(params[:sort_direction]) ? params[:sort_direction] : 'asc'
  end
end
