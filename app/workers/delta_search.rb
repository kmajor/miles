class DELTASearch
  include Sidekiq::Worker
  
  AIRLINE_ALIAS = "DELTA"

  DELTA_CABIN_TYPE = {:economy => "NK", :business => "OK", :first => "RK", :multiple => "Multiple Cabins"}
  
  # AA_AWARD_TYPE = {:saver => "M", :anytime => "A"}
  
  # AA_AWARD_CLASSES = {
  # :main_cabin => {:css => "caEconomy-Mile-SAAver", :type => AA_AWARD_TYPE[:saver], :cabin => AA_CABIN_TYPE[:economy]},
  # :business_first => {:css => "caEconomy-AAnytime", :type => AA_AWARD_TYPE[:anytime], :cabin => AA_CABIN_TYPE[:economy]}
  # }

  def send_request(url)
    args = %w{--load-images=false}
    browser = Watir::Browser.new(:phantomjs, :args => args)
    # browser.driver.manage.timeouts.implicit_wait = 60 #3 seconds
    browser.goto url
    browser
  end
  
  def perform(search_id)
    begin
      search = Search.find(search_id)

      browser = send_request("http://www.delta.com/air-shopping/searchFlights.action?tripType=ONE_WAY")
      # if browser.title !~ /Award Reservations Flight Search/
      #   browser.close
      #   raise "tacos 4 pacos" 
      # end
      
      origin_field = browser.text_field :id => "shopping_originCity_0"
      destination_field = browser.text_field :id => "shopping_destinationCity_0"
      departure_date_field = browser.text_field :id => "shopping_departureDate_0"
      currency_field = browser.div :text => "Miles"
      
    

      # search_type_field = browser.radio :id => "awardFlightSearchForm.tripType.oneWay"
      # date_type_button = browser.radio :id => "awardFlightSearchForm.datesFlexible.false"
      # award_cabin_field = browser.select_list :name => 'awardCabinClass'
      # award_type_field = browser.select_list :name => 'awardType'
  
      currency_field.when_present.click
      origin_field.when_present.value = search.origin.iata
      destination_field.when_present.value = search.destination.iata
      departure_date = search.departure_date.strftime("%m/%d/%Y")
      browser.execute_script("document.getElementById('shopping_departureDate_0').value = '#{departure_date}';") #field is readonly so Watir won't allow it to be manually modified, so we manually execute javascript to modify it #hacky
      # departure_date_field.set(search.departure_date.strftime("%m/%d/%Y"))

      browser.button(:id=>'submitAdvanced').when_present.click

      browser.div(:id => '_fareDisplayContainer_tmplHolder').wait_until_present(15) #wait for search to finish and results to display. Patience motherfucker!!

      awards_columns = browser.tds(:class => 'tblContSmallCol twoFareDisplayCol')
      
      award_results = Hash[DELTA_CABIN_TYPE.keys.map {|x| [x,nil]}]
      
      awards_columns.each do |award_column|
        award_type = DELTA_CABIN_TYPE.key(award_column.div(:class => 'frmTxtHldr flightCabinClass').a.text)
        award_mileage = award_column.span(:class => 'tblCntBigTxt mileage').text.sub(',','').to_i
        award_results[award_type] = award_mileage if award_results[award_type].nil? or award_results[award_type] > award_mileage 
      end


#      File.write('/home/ubuntu/workspace/public/burrito.html', URI.unescape(browser.html).force_encoding('utf-8'))

  #    award_class_available = browser.li(:class => "#{award_class_data[:css]}" + "_selected").exists?
  #    miles_cost = award_class_available ? browser.span(:id => 'flightTabMiles_0').text.sub(',','').to_i : nil
  
      browser.close
      
      #search_result = search.result_by_airline(Airline.where(:alias => "AA").first).first
      #results = search_result.results.nil? ? [] : Marshal.load(search_result.results)
  
      #results << {award_class => miles_cost}
      #results = Marshal.dump(available_classes)

      SearchResult.create({:airline => Airline.where(:alias => AIRLINE_ALIAS).first, :search => search, :results => award_results})

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