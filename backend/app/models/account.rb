class Account < ApplicationRecord
  has_secure_password

  has_many :profile_accesses
  has_many :profiles, through: :profile_accesses
  has_many :verifications
  has_many :subscriptions

  validates :account_type, presence: true, inclusion: { in: %w[individual parent] }
  validate :email_or_phone_present

  private

  def email_or_phone_present
    if email.blank? && phone.blank?
      errors.add(:base, "must provide either an email or a phone number")
    end
  end
end