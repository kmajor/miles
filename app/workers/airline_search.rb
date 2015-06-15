class AirlineSearch
  include Sidekiq::Worker
  def perform(search_id, airline_alias)
    sleep(1) #Eliminates race condition due to Phantom seeing open ports that then get taken by the previous call.  It's a hack, there needs to be a better solution but as of now there doesn't seem to be to much in the phantom documentation about port specification.
    self.send airline_alias + "_Search", search_id
  end

  def UA_Search(search_id)
    if Rails.configuration.use_concurrent_search
      UASearch.perform_async({search_id: search_id})
    else
      UASearch.new.perform({search_id: search_id})
    end
  end

  def AA_Search(search_id)
    # AASearch.new.perform(:economy_saver, search_id)
    if Rails.configuration.use_concurrent_search
      AASearch.perform_async({search_id: search_id})
    else 
      AASearch.new.perform({search_id: search_id})
    end
  end

  def DELTA_Search(search_id)
    # DELTA_Search.new.perform(search_id)
    if Rails.configuration.use_concurrent_search
      DELTASearch.perform_async(search_id)
    else 
      DELTASearch.new.perform(search_id)
    end
  end

  def create_connection_mechanize
    Mechanize.new
  end
  
  def create_connection_watir
    args = %w{--load-images=false}
    Watir::Browser.new(:phantomjs, :args => args)
  end
  
  def write_page_to_file(file_path, content)
    File.write(file_path, URI.unescape(content).force_encoding('utf-8'))
  end

  def write_results(args)
    SearchResult.create({:airline =>Airline.where(:alias => args[:airline_alias]).first, :search => args[:search], :results => args[:results]})
  end

end