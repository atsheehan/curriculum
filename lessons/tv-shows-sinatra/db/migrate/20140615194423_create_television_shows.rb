class CreateTelevisionShows < ActiveRecord::Migration
  def change
    create_table :television_shows do |t|
      t.string :title, null: false
      t.string :network, null: false
      t.integer :starting_year, null: false
      t.integer :ending_year
      t.string :genre

      t.text :synopsis, length: 5000
    end
  end
end
