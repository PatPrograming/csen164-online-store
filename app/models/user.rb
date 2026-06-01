class User < ApplicationRecord
  has_secure_password

  has_many :orders, dependent: :destroy
  has_many :reviews, dependent: :destroy

  before_validation :normalize_email

  validates :name, presence: true
  validates :email,
            presence: true,
            uniqueness: { case_sensitive: false },
            format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 6 }, allow_nil: true

  def admin?
    admin
  end

  private

  def normalize_email
    self.email = email.to_s.downcase.strip
  end
end
