class Vouch < ApplicationRecord
  belongs_to :profile

  validates :voucher_name, presence: true
  validates :voucher_role, presence: true, inclusion: {
    in: %w[pastor elder family_friend other]
  }
  validates :status, presence: true, inclusion: { in: %w[pending verified] }
end