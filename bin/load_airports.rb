#!/usr/bin/env ruby
file = File.read('airport_codes/airports.json')
airport_codes = JSON.parse(file)
airport_codes.each do |airport|
 airport[1]['openflight_id'] = airport[0] 
 Airport.new(airport[1]).save
end