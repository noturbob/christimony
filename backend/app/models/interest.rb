class Interest < ApplicationRecord
  belongs_to :sender_profile, class_name: "Profile"
  belongs_to :receiver_profile, class_name: "Profile"

  validates :status, presence: true, inclusion: { in: %w[pending accepted declined] }
  validates :sender_profile_id, uniqueness: { scope: :receiver_profile_id }
  validate :cannot_send_interest_to_self

  private

  def cannot_send_interest_to_self
    if sender_profile_id == receiver_profile_id
      errors.add(:base, "cannot send an interest to yourself")
    end
  end
end