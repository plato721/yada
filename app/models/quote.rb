class Quote < ApplicationRecord
  belongs_to :season
  belongs_to :character
  belongs_to :episode

  validates :body, presence: true, uniqueness: true
end
