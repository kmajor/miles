class AASearch
  include Sidekiq::Worker
  
  AIRLINE_ALIAS = "AA"

  AA_CABIN_TYPE = {:economy => "E", :business => "B", :first => "P"}
  AA_AWARD_TYPE = {:saver => "M", :anytime => "A"}
  
  AA_AWARD_CLASSES = {
  :economy_saver => {:css => "caEconomy-Mile-SAAver", :type => AA_AWARD_TYPE[:saver], :cabin => AA_CABIN_TYPE[:economy]},
  :economy_anytime => {:css => "caEconomy-AAnytime", :type => AA_AWARD_TYPE[:anytime], :cabin => AA_CABIN_TYPE[:economy]},
  :business_saver => {:css => "caBusiness-MileSAAver", :type => AA_AWARD_TYPE[:saver], :cabin => AA_CABIN_TYPE[:business]},
  :business_anytime => {:css => "caBusiness-AAnytime", :type => AA_AWARD_TYPE[:anytime], :cabin => AA_CABIN_TYPE[:business]},
  :first_saver => {:css => "caFirst-MileSAAver", :type => AA_AWARD_TYPE[:saver], :cabin => AA_CABIN_TYPE[:first]},
  :first_anytime => {:css => "caFirst-AAnytime", :type => AA_AWARD_TYPE[:anytime], :cabin => AA_CABIN_TYPE[:first]}}

  GET_AWARD_INFO_JS = <<-JS
awards = [];
myArray = safv.sliceLists[0].availablePricings;
for (var i=0,  tot=myArray.length; i < tot; i++) {
  award = {}
  award.type = myArray[i].awardType.className;
  award.miles = myArray[i].awardMiles[0];
  awards[i] = award
}
return awards;
JS


  def send_request(url)
    args = %w{--load-images=false}
    browser = Watir::Browser.new(:phantomjs, :args => args)
    # browser.driver.manage.timeouts.implicit_wait = 60 #3 seconds
    browser.goto url
    browser
  end
  
  def perform(award_class, search_id)
    begin
      award_class = award_class.to_sym #Sidekiq can't pass in symbols (due to JSON encoding), so we need to resymbolize the award_class symbol
      search = Search.find(search_id)

      browser = send_request("http://www.aa.com/reservation/awardFlightSearchAccess.do")
      # if browser.title !~ /Award Reservations Flight Search/
      #   browser.close
      #   raise "tacos 4 pacos" 
      # end
      
      award_class_data = AA_AWARD_CLASSES[award_class]
      
      origin_field = browser.text_field :name => "originAirport"
      destination_field = browser.text_field :name => "destinationAirport"
      departure_date_month_field = browser.select_list :name => "flightParams.flightDateParams.travelMonth"
      departure_date_day_field = browser.select_list :name => "flightParams.flightDateParams.travelDay"
      departure_date_time_field = browser.select_list :name => "flightParams.flightDateParams.searchTime"
      search_type_field = browser.radio :id => "awardFlightSearchForm.tripType.oneWay"
      date_type_button = browser.radio :id => "awardFlightSearchForm.datesFlexible.false"
      award_cabin_field = browser.select_list :name => 'awardCabinClass'
      award_type_field = browser.select_list :name => 'awardType'
  
      origin_field.when_present.value = search.origin.iata
      destination_field.when_present.value = search.destination.iata
      departure_date_month_field.options[search.departure_date.month-1].when_present.select
      departure_date_day_field.options[search.departure_date.day-1].when_present.select
      departure_date_time_field.options[0].select #First Element in list is 'All Day'
      search_type_field.when_present.set
      date_type_button.when_present.set
      
      award_cabin_field.when_present.select_value award_class_data[:cabin]
      award_type_field.when_present.select_value award_class_data[:type]
      browser.button(:name=>'_button_success').when_present.click

      browser.ul(:id => 'awardList').wait_until_present(15)
  #    award_class_available = browser.li(:class => "#{award_class_data[:css]}" + "_selected").exists?
  #    miles_cost = award_class_available ? browser.span(:id => 'flightTabMiles_0').text.sub(',','').to_i : nil
  
  #    File.write('/home/ubuntu/workspace/public/burrito.html', URI.unescape(browser.html).force_encoding('utf-8'))

      available_awards = browser.execute_script(GET_AWARD_INFO_JS)

      results = {}
      available_awards.each {|award| results[award["type"]]=award["miles"]}
      
      browser.close
      
      #search_result = search.result_by_airline(Airline.where(:alias => "AA").first).first
      #results = search_result.results.nil? ? [] : Marshal.load(search_result.results)
  
      #results << {award_class => miles_cost}
      #results = Marshal.dump(available_classes)


      SearchResult.create({:airline => Airline.where(:alias => AIRLINE_ALIAS).first, :search => search, :results => results})

    rescue Timeout::Error, Errno::ECONNREFUSED => e 
      if attempts < UA_MAX_ATTEMPTS
        browser.close if browser.respond_to?(:close)
        retry
      else
        SearchResult.create({:airline =>Airline.where(:alias => AIRLINE_ALIAS).first, :search => search, :results => {error: e.message}})
      end
    ensure
      browser.close if browser.respond_to?(:close)
    end
  end
end