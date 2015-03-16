class TelevisionShow < ActiveRecord::Base
  GENRES = ["Action", "Mystery", "Drama", "Comedy", "Fantasy"]

  validates :title, presence: true
  validates :genre, inclusion: { in: GENRES }

  validates :starting_year, presence: true, numericality: {
    greater_than: 1900
  }

  validates :ending_year, allow_nil: true, numericality: {
    greater_than: 1900
  }

  validates :synopsis, length: { maximum: 5000 }
end
