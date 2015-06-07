class CreateSearchResults < ActiveRecord::Migration
  def change
    enable_extension "hstore"
    create_table :search_results do |t|
      t.references :search, index: true
      t.references :airline, index: true
      t.hstore :results

      t.timestamps
    end
  end
end
