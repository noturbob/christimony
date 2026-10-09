class Device < ApplicationRecord
  belongs_to :account

  validates :token, presence: true, uniqueness: true
  validates :platform, inclusion: { in: %w[android ios] }
end
