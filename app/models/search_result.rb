class SearchResult < ActiveRecord::Base
  belongs_to :search
  belongs_to :airline

end
