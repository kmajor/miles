class Search < ActiveRecord::Base
  has_many :results, class_name: "SearchResult"
  belongs_to :origin, class_name: "Airport"
  belongs_to :destination, class_name: "Airport"
  
  SEARCHABLE_AIRLINES=['AA','UA']
  
  def result_by_airline(airline)
    # airline_id = airline.id if airline.class == ActiveRecord::AirlineSearch
    # airline_id = airline if airline.class == String && airline.numeric?
    # raise "airline is neither a valid ID or airline object" unless defined? airline_id != nil
    return SearchResult.where :search => self, :airline => airline
  end

  def run_searches
  #  AirlineSearch.new.perform(self.id, "UA")
    SEARCHABLE_AIRLINES.each do |airline_alias|
      #AirlineSearch.perform_async(self.id, airline_alias)
      AirlineSearch.new.perform(self.id, airline_alias)
    end
  end
end
