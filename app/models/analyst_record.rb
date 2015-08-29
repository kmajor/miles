#rails g scaffold analyst_record analyst:references game_date:date matchup:string selection:string line_source:string posted_time:datetime result:integer sport_type:integer
class AnalystRecord < ActiveRecord::Base
  belongs_to :analyst
end
