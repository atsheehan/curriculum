class TelevisionShow < ActiveRecord::Base
  validates :title,
    presence: true,
    uniqueness: { scope: :network }
end
