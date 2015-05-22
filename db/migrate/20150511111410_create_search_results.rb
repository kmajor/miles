class CreateSearchResults < ActiveRecord::Migration
  def change
    create_table :search_results do |t|
      t.references :search, index: true
      t.references :airline, index: true
      t.text :results

      t.timestamps
    end
  end
end
