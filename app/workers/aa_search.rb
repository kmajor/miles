class AaSearch
  include Sidekiq::Worker
  def perform(award_class, search_id)
    search = Search.find(search_id)
    award_class_css = Search::AA_AWARD_CLASSES[award_class]
    browser = Watir::Browser.new :phantomjs
    search_url = "http://www.aa.com/reservation/awardFlightSearchAccess.do"
    browser.goto search_url

    origin_field = browser.text_field :name => "originAirport"
    destination_field = browser.text_field :name => "destinationAirport"
    departure_date_month_field = browser.select_list :name => "flightParams.flightDateParams.travelMonth"
    departure_date_day_field = browser.select_list :name => "flightParams.flightDateParams.travelDay"
    departure_date_time_field = browser.select_list :name => "flightParams.flightDateParams.searchTime"
    search_type_field = browser.radio(:id => "awardFlightSearchForm.tripType.oneWay")
    date_type_button = browser.radio(:id => "awardFlightSearchForm.datesFlexible.false")

    origin_field.value = search.origin.iata
    destination_field.value = search.destination.iata
    departure_date_month_field.options[search.departure_date.month].select
    departure_date_day_field.options[search.departure_date.day].select
    departure_date_time_field.options[0].select #First Element in list is 'All Day'
    search_type_field.set
    date_type_button.set
    browser.button(:name=>'_button_success').click

    seat_class_available = noko.css(award_class_css + "_selected").exists?
    miles_cost = seat_class_available ? browser.css('#flightTabMiles_0').text.sub(',','').to_i : nil

    search_result = search.result_by_airline(airline)
    results = Marshal.load(search_result.result)
    results << {seat_class => miles_cost}
    results = Marshal.dump(results)
    
    search_result.result = results
    search_result.save!
    
  end
end