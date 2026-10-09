class Account < ApplicationRecord
  has_many :profile_accesses, dependent: :delete_all
  has_many :profiles, through: :profile_accesses
  has_many :verifications, dependent: :delete_all
  has_many :subscriptions, dependent: :delete_all
  has_many :blocks, dependent: :delete_all
  has_many :devices, dependent: :delete_all
  has_many :reports, foreign_key: :reporter_account_id, dependent: :nullify
  # Messages sent as a co-pilot in conversations of profiles this account
  # doesn't own (those conversations survive the account).
  has_many :sent_messages, class_name: "Message", foreign_key: :sender_account_id, dependent: :delete_all

  # Must run before the dependents above delete the owner accesses it reads.
  before_destroy :destroy_owned_profiles, prepend: true

  scope :managing, ->(profile_ids) { where(id: ProfileAccess.where(profile_id: profile_ids).select(:account_id)) }

  before_validation :normalize_phone

  validates :account_type, presence: true, inclusion: { in: %w[individual parent] }
  validates :email, uniqueness: true, allow_nil: true
  validates :phone, uniqueness: true, allow_nil: true
  validates :oauth_uid, uniqueness: { scope: :oauth_provider }, allow_nil: true
  validate :identity_present
  validate :credential_present

  # Profiles hidden from this account by a block in either direction.
  def hidden_profile_ids
    @hidden_profile_ids ||= blocks.pluck(:blocked_profile_id) |
      ProfileAccess.where(account_id: Block.where(blocked_profile_id: profile_accesses.select(:profile_id)).select(:account_id)).pluck(:profile_id)
  end

  def can_view_profile?(profile)
    (profile.status == "active" || profile_accesses.exists?(profile_id: profile.id)) &&
      hidden_profile_ids.exclude?(profile.id)
  end

  private

  def destroy_owned_profiles
    Profile.where(id: profile_accesses.where(role: "owner").select(:profile_id)).find_each(&:destroy!)
  end

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
