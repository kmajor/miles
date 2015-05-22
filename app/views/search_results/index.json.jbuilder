json.array!(@search_results) do |search_result|
  json.extract! search_result, :id, :search_id, :airline_id, :results
  json.url search_result_url(search_result, format: :json)
end
