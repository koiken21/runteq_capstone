class User < ApplicationRecord
  belongs_to :organization

  has_secure_password

  ROLES = %w[admin supporter].freeze

  validates :role, presence: true, inclusion: { in: ROLES }

  scope :admin, -> { where(role: "admin") }
  scope :supporter, -> { where(role: "supporter") }

  def admin?
    role == "admin"
  end

  def supporter?
    role == "supporter"
  end

  def generate_registration_token!
    self.registration_token = SecureRandom.hex(10)
    self.registration_token_sent_at = Time.current
    save!
  end

  def registration_token_valid?
    registration_token_sent_at && registration_token_sent_at > 2.days.ago
  end

  def clear_registration_token!
    update!(registration_token: nil, registration_token_sent_at: nil)
  end
end
