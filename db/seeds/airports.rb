#!/usr/bin/env ruby
#rails g scaffold search origin:references destination:references departure_date:date arrival_date:date ip_address:inet_address
file = File.read('airport_codes/airports.json')
airport_codes = JSON.parse(file)
airport_codes.each do |airport|
 airport[1]['openflight_id'] = airport[0] 
 Airport.new(airport[1]).save
end