json.array!(@airlines) do |airline|
  json.extract! airline, :id, :openflight_id, :name, :alias, :iata, :iaco, :callsign, :country, :active
  json.url airline_url(airline, format: :json)
end
