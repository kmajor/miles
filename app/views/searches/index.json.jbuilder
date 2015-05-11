json.array!(@searches) do |search|
  json.extract! search, :id, :origin_id, :destination_id, :departure_date, :arrival_date, :ip_address
  json.url search_url(search, format: :json)
end
