require 'geokit'

Geokit::Geocoders::GoogleGeocoder.api_key = ENV['GOOGLE_API_KEY']
Geokit::default_units = :meters
