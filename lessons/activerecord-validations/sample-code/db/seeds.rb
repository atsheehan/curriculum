require "csv"
require_relative "../models/song"

CSV.foreach("./db/songs.csv", headers: :symbol) do |row|
  Song.find_or_create_by!(row.to_hash)
end
