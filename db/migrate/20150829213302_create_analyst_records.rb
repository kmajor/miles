class CreateAnalystRecords < ActiveRecord::Migration
  def change
    create_table :analyst_records do |t|
      t.references :analyst, index: true, foreign_key: true
      t.date :game_date
      t.string :matchup
      t.string :selection
      t.string :line_source
      t.datetime :posted_time
      t.integer :result
      t.integer :sport_type

      t.timestamps null: false
    end
  end
end
