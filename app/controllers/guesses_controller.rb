class GuessesController < ApplicationController
  def create
    result = PlayGame.call(
      token: request.headers['Authorization']&.split(' ')&.last,
      guess_coordinates: "#{guess_params[:lat]},#{guess_params[:long]}")

    if result.success?
      render json: { message: result.message }, status: :ok
    else
      render json: { error: result.error }, status: result.status
    end
  end

  private

  def guess_params
    params.require(:guess).permit(:lat, :long)
  end
end
