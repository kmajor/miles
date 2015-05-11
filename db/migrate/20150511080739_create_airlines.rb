class CreateAirlines < ActiveRecord::Migration
  def change
    create_table :airlines do |t|
      t.string :openflight_id
      t.string :name
      t.string :alias
      t.string :iata
      t.string :iaco
      t.string :callsign
      t.string :country
      t.boolean :active

      t.timestamps
    end
  end
end
