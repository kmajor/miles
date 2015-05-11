json.array!(@airports) do |airport|
  json.extract! airport, :id, :openflight_id, :name, :city, :country, :iata, :icao, :latitude, :longitude, :altitude, :timezone, :dst
  json.url airport_url(airport, format: :json)
end
