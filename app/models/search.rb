class Search < ActiveRecord::Base
  has_many :results, class_name: "SearchResult"
  belongs_to :origin, class_name: "Airport"
  belongs_to :destination, class_name: "Airport"
  
  SEARCHABLE_AIRLINES=['AA']
  
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
