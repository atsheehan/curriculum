class CreateTelevisionShows < ActiveRecord::Migration
  def change
    create_table :television_shows do |t|
      t.string :title, null: false
      t.string :network
    end

    add_index :television_shows, [:title, :network], unique: true
  end
end
