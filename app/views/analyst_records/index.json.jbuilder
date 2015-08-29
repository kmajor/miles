json.array!(@analyst_records) do |analyst_record|
  json.extract! analyst_record, :id, :analyst_id, :game_date, :matchup, :selection, :line_source, :posted_time, :result, :sport_type
  json.url analyst_record_url(analyst_record, format: :json)
end
