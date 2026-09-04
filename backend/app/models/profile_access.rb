class ProfileAccess < ApplicationRecord
  belongs_to :profile
  belongs_to :account

  validates :role, presence: true, inclusion: { in: %w[owner co_pilot] }
  validates :account_id, uniqueness: { scope: :profile_id }
end