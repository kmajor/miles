class Search < ActiveRecord::Base
  has_many :results, class_name: "SearchResult"
  belongs_to :origin, class_name: "Airport"
  belongs_to :destination, class_name: "Airport"
  
  SEARCHABLE_AIRLINES=['AA']
  
  AA_AWARD_CLASSES = {
  :economy_saver => "caEconomy-MileSAAver",
  :economy_anytime => "caEconomy-AAnytime",
  :business_saver => "caBusiness-MilesSAAver",
  :business_anytime => "caBusiness-AAnytime",
  :first_saver => "caFirst-MileSAAver",
  :first_anytime => "caFirst-AAnytime"}


  def result_by_airline(airline)
    # airline_id = airline.id if airline.class == ActiveRecord::AirlineSearch
    # airline_id = airline if airline.class == String && airline.numeric?
    # raise "airline is neither a valid ID or airline object" unless defined? airline_id != nil
    return SearchResult.where :search => self, :airline => airline
  end

  
  def run_searches
    SEARCHABLE_AIRLINES.each do |airline_alias|
      # AirlineSearch.perform_async(self.id, airline_alias)
      AirlineSearch.new.perform(self.id, airline_alias)
    end
  end


  def AA_search
    availability = {:economy_saver => [], :economy_standard => [], :business_saver => [], :business_standard => [], :first_class_saver => [], :first_class_standard => []}
    seat_classes = [:economy_saver, :economy_standard, :business_saver, :business_standard, :first_class_saver, :first_class_standard]
    

    # hydra = Typhoeus::Hydra.hydra

    # first_request = Typhoeus::Request.new("http://www.aa.com/reservation/awardFlightSearchOptionsSubmit.do")
    # first_request.on_complete do |response|
    #   Nokogiri::HTML(response.response_body)
    #   binding.pry
                  
    #   # third_url = response.body
    #   # third_request = Typhoeus::Request.new(third_url)
    #   # hydra.queue third_request
    # end

    # hydra.queue first_request
    # hydra.run # this is a blocking call that returns once all requests are complete
    
  end    
  
end
