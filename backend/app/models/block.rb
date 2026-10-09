class Block < ApplicationRecord
  belongs_to :account
  belongs_to :blocked_profile, class_name: "Profile"

  validates :blocked_profile_id, uniqueness: { scope: :account_id }
  validate :not_own_profile

  private

  def not_own_profile
    if account && blocked_profile_id && account.profile_accesses.exists?(profile_id: blocked_profile_id)
      errors.add(:base, "You can't block a profile you manage")
    end
  end
end
