#!/usr/bin/env ruby
# rails g scaffold search origin:references destination:references departure_date:date arrival_date:date ip_address:inet_address

file = File.read('airport_codes/airports.json')
airport_codes = JSON.parse(file)
airport_codes.each do |airport|
 airport[1]['openflight_id'] = airport[0] 
 Airport.new(airport[1]).save
end

#rails g scaffold airlines openflight_id:string name:string alias:string iata:string iaco:string callsign:string country:string active:boolean      
airlines=[{name: 'United', alias: "UA"}, {name:'American', alias:"AA"}]
airlines.each do |airline|
 Airline.create(airline).save
end
