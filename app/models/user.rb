# frozen_string_literal: true

class User < ApplicationRecord
  has_many :user_searches, class_name: 'UserSearch'
  has_many :searches, through: :user_searches

  validates :email, presence: true, uniqueness: true
  before_validation :downcase_email

  validates :token, presence: true, uniqueness: true
  before_validation :set_token

  def downcase_email
    self.email ||= ''
    self.email = email.downcase
  end

  def set_token
    self.token = SecureRandom.hex(16) if token.blank?
  end
end
