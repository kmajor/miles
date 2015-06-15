class AASearch < AirlineSearch
  include Sidekiq::Worker
  
  AA_ALIAS = "AA"

  AA_CABIN_TYPE = {:economy => "E", :business => "B", :first => "P"}
  AA_AWARD_TYPE = {:saver => "M", :anytime => "A"}
  
  AA_SEARCH_URL = 'http://www.aa.com/reservation/awardFlightSearchAccess.do'
  AA_PAGE_VIEW_TEMP_FILE = '/home/ubuntu/workspace/public/aa.html'
  
  
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

  def perform(args)
    initialize_variables(args)
    begin
      @attempts += 1
      @browser = create_connection_watir
      retrieve_page(AA_SEARCH_URL)
      set_fields
      submit_form
      #      write_page_to_file(UA_RESULTS_TEMP_FILE, @agent.page.content)
      parse_award_data
      process_results
      write_results

    rescue Timeout::Error, Errno::ECONNREFUSED => e 
      if @attempts < AA_MAX_ATTEMPTS
        close_connection
        retry
      else
        @results = {error: e.message}
        write_results
      end
    ensure
      close_connection
    end
  end
  
  def close_connection
    @browser.close if @browser.respond_to?(:close)
  end

  
  private
  
    def retrieve_page(url)
      @browser.goto url
    end
  
    def initialize_variables(args)
      @results = {}
      @attempts = 0
      @search = Search.find(args[:search_id])
    end
    
    def set_fields
      @browser.text_field(:name => "originAirport").value = @search.origin.iata
      @browser.text_field(:name => "destinationAirport").when_present.value = @search.destination.iata
      @browser.select_list(:name => "flightParams.flightDateParams.travelMonth").options[@search.departure_date.month-1].when_present.select
      @browser.select_list(:name => "flightParams.flightDateParams.travelDay").options[@search.departure_date.day-1].when_present.select
      @browser.select_list(:name => "flightParams.flightDateParams.searchTime").options[0].select
      @browser.radio(:id => "awardFlightSearchForm.tripType.oneWay").when_present.set
      @browser.radio(:id => "awardFlightSearchForm.datesFlexible.false").when_present.set
      @browser.select_list(:name => 'awardCabinClass').when_present.select_value AA_CABIN_TYPE[:economy]
      @browser.select_list(:name => 'awardType').when_present.select_value AA_AWARD_TYPE[:anytime]
    end
    
    def submit_form
      @browser.button(:name=>'_button_success').when_present.click
    end
    
    def parse_award_data
      @browser.ul(:id => 'awardList').wait_until_present(15)
      @available_awards = @browser.execute_script(GET_AWARD_INFO_JS)
    end
  
    def process_results
      @available_awards.each {|award| @results[award["type"]]=award["miles"]}
    end
    
    def write_results
      super({search: @search, airline_alias: AA_ALIAS, results: @results})
    end
end