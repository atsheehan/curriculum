class CreateSongs < ActiveRecord::Migration
  def change
    create_table :songs do |t|
      t.string :title
      t.string :artist
      t.string :album
      t.integer :year
      t.integer :track_number
      t.string :genre
      t.integer :length_in_seconds
      t.string :image

      t.timestamps null: false
    end
  end
end
