class SearchResult < ActiveRecord::Base
  belongs_to :search
  belongs_to :airline

  after_save :notify_search_result_added

  def self.on_change
    SearchResult.connection.execute "LISTEN search_results"
    loop do
      SearchResult.connection.raw_connection.wait_for_notify do |event, pid, result|
        yield result
      end
    end
  ensure
    SearchResult.connection.execute "UNLISTEN search_results"
  end

  def notify_search_result_added
    SearchResult.connection.execute "NOTIFY search_results, '#{self.id}'"
  end


end
