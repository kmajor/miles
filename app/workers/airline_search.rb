

    results = browser.button(:name=>'_button_success').click

    noko.css('#flightTabMiles_0').text
    noko.css('.caEconomy-MileSAAver_selected')

  award_classes = {
    :economy_saver => "caEconomy-MileSAAver",
    :economy_anytime => "caEconomy-AAnytime",
    :business_saver => "caBusiness-MilesSAAver",
    :business_anytime => "caBusiness-AAnytime",
    :first_saver => "caFirst-MileSAAver",
    :first_anytime => "caFirst-AAnytime"
  }
  
  
    
    
    
    

    File.write('/home/ubuntu/workspace/public/burrito.html', URI.unescape(browser.html).force_encoding('utf-8'))

binding.pry

    # agent = Mechanize.new
    # page = agent.get("http://www.aa.com/reservation/awardFlightSearchAccess.do")

    # search_form = page.form("awardFlightSearchForm")

    # origin_field = browser.text_field :name => "originAirport"
    # destination_field = browser.text_field :name => "destinationAirport"
    # departure_date_month_field = browser.select_list :name => "flightParams.flightDateParams.travelMonth"
    # departure_date_day_field = browser.select_list :name => "flightParams.flightDateParams.travelDay"
    # departure_date_time_field = browser.select_list :name => "flightParams.flightDateParams.searchTime"
    
    # search_type_button = search_form.radiobutton_with :value => "oneWay"
    # date_type_button = search_form.radiobutton_with(:id => "awardFlightSearchForm.datesFlexible.false")

    # origin_field.value = search.origin.iata
    # destination_field.value = search.destination.iata
    # departure_date_month_field.options[search.departure_date.month].select
    # departure_date_day_field.options[search.departure_date.day].select
    # departure_date_time_field.options[0].select #First Element in list is 'All Day'

    # search_type_button.check
    # date_type_button.check

    # results = search_form.submit(search_form.button_with(:name=>'_button_success'))

    # File.write('/home/ubuntu/workspace/public/burrito.html', URI.unescape(agent.page.content).force_encoding('utf-8'))



    #intialize hashes
    # miles_data = Hash[united_seat_classes.map { | x | [x, nil] }]
    # united_availability = Hash[united_seat_classes.map { | x | [x, []] }]

    # award_fields = results.parser.css('div#rewardSegments').css('div.divMileage')
    # award_fields.each_with_index do |award, index|
    #   next if award.children.empty?
    #   seat_class = united_seat_classes[index % 6]
    #   miles_cost = award.children.first.text.split(" ")[0].sub(',','').to_i
    #   united_availability[seat_class] << miles_cost
    # end

    # united_availability.each do |category, miles| 
    #   miles_data[category] = miles.min
    # end

    # miles_data = Marshal.dump(miles_data)
    # SearchResult.create({:airline =>airline, :search => search, :results => miles_data})

  end

end