# frozen_string_literal: true

class Character < ApplicationRecord
  has_many :quotes
  validates :name, presence: true, uniqueness: true

  def as_json(_ = {})
    {
      id: id,
      name: name
    }
  end
end
