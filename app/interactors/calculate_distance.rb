class CalculateDistance
  include Interactor

  def call
    treasure = Treasure.find_by(found: false)

    if treasure
      guess_location = Geokit::Geocoders::GoogleGeocoder.geocode(context.guess_coordinates)
      distance = guess_location.distance_to("#{treasure.lat},#{treasure.long}").to_i
      context.distance = distance
      context.treasure = treasure
    else
      context.status = :not_found
      context.fail!(error: "No treasures available")
    end
  end
end
