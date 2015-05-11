class CreateAirports < ActiveRecord::Migration
  def change
    create_table :airports do |t|
      t.string :openflight_id
      t.string :name
      t.string :city
      t.string :country
      t.string :iata
      t.string :icao
      t.string :latitude
      t.string :longitude
      t.string :altitude
      t.decimal :timezone
      t.string :dst

      t.timestamps
    end
  end
end
