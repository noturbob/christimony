class Subscription < ApplicationRecord
  belongs_to :account

  validates :plan, presence: true, inclusion: { in: %w[free premium family] }
  validates :status, presence: true, inclusion: { in: %w[active expired cancelled] }
  validates :started_at, presence: true
  validate :only_one_active_subscription_per_account

  before_validation :set_started_at, on: :create

  private

  def set_started_at
    self.started_at ||= Time.current
  end

  def only_one_active_subscription_per_account
    return unless status == "active"

    existing = Subscription.where(account_id: account_id, status: "active")
    existing = existing.where.not(id: id) if persisted?

    if existing.exists?
      errors.add(:base, "account already has an active subscription")
    end
  end
end