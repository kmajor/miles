class UASearch
#removed all iterpolated strings
#moved hard coded values out of code into config/class constants
#perform is a terribly named method for containing all the functional code for search, break all the code out and sequence it
#


  include Sidekiq::Worker

  UA_AIRLINE_ALIAS = "UA"
  UA_AWARD_CLASSES = [:economy_saver, :economy_standard, :business_saver, :business_standard, :first_class_saver, :first_class_standard]
  UA_MAX_ATTEMPTS = 3
  UA_SEARCH_URL = 'http://www.united.com/web/en-US/apps/booking/flight/searchOW.aspx?CS=N'
  UA_CSS_SEARCH_FIELDS = {
    search_form: 'aspnetForm',
    origin: "ctl00$ContentInfo$SearchForm$Airports1$Origin$txtOrigin",
    destination: 'ctl00$ContentInfo$SearchForm$Airports1$Destination$txtDestination',
    departure_date: 'ctl00$ContentInfo$SearchForm$DateTimeCabin1$Depdate$txtDptDate',
    search_by_radio_button: 'rdosearchby3',
    submit_button: 'ctl00$ContentInfo$SearchForm$searchbutton'
  }
  UA_CSS_RESULTS_FIELDS = {
  reward_segments: 'div#rewardSegments',
  mileage: 'div.divMileage'
  }
  UA_RESULTS_TEMP_FILE = '/home/ubuntu/workspace/public/ua.html'
  
  def close_connection
    @agent.shutdown if @agent.respond_to?(:shutdown)
  end

  def perform(args)
    initialize_variables(args)
    begin
      @attempts += 1
      create_connection
      retrieve_page(UA_SEARCH_URL)
      set_fields
      submit_form
      parse_award_data
      process_results
      write_results
    rescue Timeout::Error, Errno::ECONNREFUSED => e 
      if @attempts < UA_MAX_ATTEMPTS
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
  
  private
  
  def create_connection
      @agent = Mechanize.new
  end
  
  def retrieve_page(url)
      @agent.get(url)
  end
  
  def initialize_variables(args)
    @attempts = 0
    @search = Search.find(args[:search_id])
    @results = Hash[UA_AWARD_CLASSES.map { | x | [x, nil] }]
  end

  def search_form
    @agent.page.nil? ? nil : @agent.page.form(UA_CSS_SEARCH_FIELDS[:search_form])
  end
  
  def set_fields
    search_form.field_with(:name => UA_CSS_SEARCH_FIELDS[:origin]).value = @search.origin.iata
    search_form.field_with(:name => UA_CSS_SEARCH_FIELDS[:destination]).value = @search.destination.iata
    search_form.field_with(:name => UA_CSS_SEARCH_FIELDS[:departure_date]).value = @search.departure_date.strftime("%m/%d/%Y")
    search_form.radiobutton_with(:value => UA_CSS_SEARCH_FIELDS[:search_by_radio_button]).check
  end

  def submit_form
    search_form.submit(search_form.button_with(:name => UA_CSS_SEARCH_FIELDS[:submit_button]))
  end

  def write_page_to_file
    File.write(US_TEMP_RESULTS_FILE, URI.unescape(@agent.page.content).force_encoding('utf-8'))
  end
  
  def parse_award_data
    @award_fields = @agent.page.parser.css(UA_CSS_RESULTS_FIELDS[:reward_segments]).css(UA_CSS_RESULTS_FIELDS[:mileage])
  end  

  def process_results
      # OPTIMIZE this needs to be redone, but further result processing will be much more robust storing all results in the db, for now this is a temp holder until we decide how much data we want to store and display
    @award_fields.each_with_index do |award, index|
      next if award.children.empty?
      seat_class = UA_AWARD_CLASSES[index % 6]
      miles_cost = award.children.first.text.split(" ")[0].sub(',','').to_i
      @results[seat_class] = miles_cost if @results[seat_class].nil? or @results[seat_class] > miles_cost
    end
  end
  
  def write_results
    SearchResult.create({:airline =>Airline.where(:alias => UA_AIRLINE_ALIAS).first, :search => @search, :results => @results})
  end
  
end