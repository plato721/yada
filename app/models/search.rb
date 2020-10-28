# frozen_string_literal: true

class Search < ApplicationRecord
  has_many :user_searches, class_name: 'UserSearch'
  has_many :users, through: :user_searches

  validates :criteria, uniqueness: true
  before_validation :downcase_criteria

  def downcase_criteria
    self.criteria ||= ''
    self.criteria = criteria.downcase
  end
end
