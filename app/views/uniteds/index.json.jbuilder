json.array!(@uniteds) do |united|
  json.extract! united, :id
  json.url united_url(united, format: :json)
end
