class UASearch

  include Sidekiq::Worker

  # UA_CABIN_TYPE = {:economy => "E", :business => "B", :first => "P"}
  # UA_AWARD_TYPE = {:saver => "M", :anytime => "A"}
  
  UA_AWARD_CLASSES = [:economy_saver, :economy_standard, :business_saver, :business_standard, :first_class_saver, :first_class_standard]
  UA_MAX_ATTEMPTS = 3
  
  def send_request(url)
    args = %w{--load-images=false}
    browser = Watir::Browser.new(:phantomjs, :args => args)
    #browser.driver.manage.timeouts.implicit_wait = 60 #3 seconds
    browser.goto url
    browser
  end
  
  def perform(search_id)
    attempt = 0
    begin
      attempt += 1
      search = Search.find(search_id)
      # browser = send_request("http://www.aa.com/reservation/awardFlightSearchAccess.do")
      # if browser.title !~ /Award Reservations Flight Search/
      #   browser.close
      #   raise "tacos 4 pacos" 
      # end
      agent = Mechanize.new
  
      page = agent.get("http://www.united.com/web/en-US/apps/booking/flight/searchOW.aspx?CS=N")
      search_form = page.form("aspnetForm")
      origin_field = search_form.field_with(:name => "ctl00$ContentInfo$SearchForm$Airports1$Origin$txtOrigin")
      destination_field = search_form.field_with(:name => "ctl00$ContentInfo$SearchForm$Airports1$Destination$txtDestination")
      departure_date_field = search_form.field_with(:name => "ctl00$ContentInfo$SearchForm$DateTimeCabin1$Depdate$txtDptDate")
      search_type_button = search_form.radiobutton_with(:value => "rdosearchby3")
  
      origin_field.value = search.origin.iata
      destination_field.value = search.destination.iata
      departure_date_field.value = search.departure_date.strftime("%m/%d/%Y")
      search_type_button.check
  
      results = search_form.submit(search_form.button_with(:name=>'ctl00$ContentInfo$SearchForm$searchbutton'))
      File.write('/home/ubuntu/workspace/public/taco.html', URI.unescape(agent.page.content).force_encoding('utf-8'))
  
      #intialize hashes
      miles_data = Hash[UA_AWARD_CLASSES.map { | x | [x, nil] }]
      united_availability = Hash[UA_AWARD_CLASSES.map { | x | [x, []] }]
  
      award_fields = results.parser.css('div#rewardSegments').css('div.divMileage')
      award_fields.each_with_index do |award, index|
        next if award.children.empty?
        seat_class = UA_AWARD_CLASSES[index % 6]
        miles_cost = award.children.first.text.split(" ")[0].sub(',','').to_i
        united_availability[seat_class] << miles_cost
      end
  
      united_availability.each do |category, miles| 
        miles_data[category] = miles.min
      end
      
      SearchResult.create({:airline =>Airline.where(:alias => "UA").first, :search => search, :results => miles_data})
    rescue Timeout::Error, Errno::ECONNREFUSED => e 
      if attempts < UA_MAX_ATTEMPTS
        agent.shutdown if agent.respond_to?(:shutdown)
        retry
      else
        SearchResult.create({:airline =>Airline.where(:alias => "UA").first, :search => search, :results => {error: e.message}})
      end
    ensure
      agent.shutdown if agent.respond_to?(:shutdown)
    end
  end
end