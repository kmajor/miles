class CreateSearches < ActiveRecord::Migration
  def change
    create_table :searches do |t|
      t.references :origin, index: true
      t.references :destination, index: true
      t.date :departure_date
      t.date :arrival_date
      t.string :ip_address

      t.timestamps
    end
  end
end
