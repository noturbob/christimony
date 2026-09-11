class Account < ApplicationRecord
  has_secure_password validations: false

  has_many :profile_accesses
  has_many :profiles, through: :profile_accesses
  has_many :verifications
  has_many :subscriptions

  before_validation :normalize_phone

  validates :account_type, presence: true, inclusion: { in: %w[individual parent] }
  validates :email, uniqueness: true, allow_nil: true
  validates :phone, uniqueness: true, allow_nil: true
  validates :password, length: { minimum: 6 }, allow_nil: true
  validate :email_or_phone_present
  validate :password_or_verified_phone_present

  private

  def normalize_phone
    return if phone.blank?

    parsed = Phonelib.parse(phone, "IN")
    self.phone = parsed.valid? ? parsed.e164 : phone
  end

  def email_or_phone_present
    if email.blank? && phone.blank?
      errors.add(:base, "must provide either an email or a phone number")
    end
  end

  # An account can exist with no password at all as long as it was created
  # via phone OTP (phone_verified_at set). Accounts created via the
  # email/password flow must set a password.
  def password_or_verified_phone_present
    if password_digest.blank? && phone_verified_at.blank?
      errors.add(:base, "must set a password or verify a phone number")
    end
  end
end
