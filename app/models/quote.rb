class Quote < ApplicationRecord
  belongs_to :season
  belongs_to :character
  belongs_to :episode

  validates :body, presence: true, uniqueness: true

  def as_json(_={})
    {
      id: id,
      body: body,
      season: season,
      character: character,
      episode: episode
    }
  end
end
