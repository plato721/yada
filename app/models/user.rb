class User < ApplicationRecord
  validates :email, presence: true, uniqueness: true
  before_validation :downcase_email

  validates :token, presence: true, uniqueness:true
  before_validation :set_token

  def downcase_email
    self.email ||= ""
    self.email = email.downcase
  end

  def set_token
    self.token = SecureRandom.hex(16) if token.blank?
  end
end
