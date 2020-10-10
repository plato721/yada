class Search < ApplicationRecord
  validates :criteria, uniqueness: true
  before_validation :downcase_criteria

  def downcase_criteria
    self.criteria = criteria.downcase
  end
end
