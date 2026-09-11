class Account < ApplicationRecord
  has_many :profile_accesses
  has_many :profiles, through: :profile_accesses
  has_many :verifications
  has_many :subscriptions

  before_validation :normalize_phone

  validates :account_type, presence: true, inclusion: { in: %w[individual parent] }
  validates :email, uniqueness: true, allow_nil: true
  validates :phone, uniqueness: true, allow_nil: true
  validates :oauth_uid, uniqueness: { scope: :oauth_provider }, allow_nil: true
  validate :identity_present
  validate :credential_present

  private

  def normalize_phone
    return if phone.blank?

    parsed = Phonelib.parse(phone, "IN")
    self.phone = parsed.valid? ? parsed.e164 : phone
  end

  def identity_present
    if email.blank? && phone.blank? && oauth_uid.blank?
      errors.add(:base, "must provide an email, a phone number, or a connected account")
    end
  end

  # Accounts are only ever created via phone OTP or OAuth (Google/Apple) --
  # there is no email/password signup, so one of those two proofs of
  # identity must be present.
  def credential_present
    if phone_verified_at.blank? && oauth_uid.blank?
      errors.add(:base, "must verify a phone number or connect a Google/Apple account")
    end
  end
end
