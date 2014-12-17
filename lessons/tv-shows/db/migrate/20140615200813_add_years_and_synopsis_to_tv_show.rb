class AddYearsAndSynopsisToTvShow < ActiveRecord::Migration
  def change
    add_column :television_shows, :years, :string
    add_column :television_shows, :synopsis, :string
  end
end
