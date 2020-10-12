class Episode < ApplicationRecord
  has_many :quotes
  validates :number, presence: true, uniqueness: true

  def as_json(_={})
    {
      id: id,
      number: number
    }
  end
end
