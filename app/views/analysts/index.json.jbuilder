json.array!(@analysts) do |analyst|
  json.extract! analyst, :id, :first_name, :last_name
  json.url analyst_url(analyst, format: :json)
end
