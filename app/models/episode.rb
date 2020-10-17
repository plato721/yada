class Episode < ApplicationRecord
  has_many :quotes
  validates :number, presence: true, uniqueness: true
end
