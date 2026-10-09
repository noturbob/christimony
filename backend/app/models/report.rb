class Report < ApplicationRecord
  REASONS = %w[spam inappropriate fake_profile harassment underage other].freeze

  belongs_to :reporter_account, class_name: "Account"
  belongs_to :reported_profile, class_name: "Profile"

  validates :reason, inclusion: { in: REASONS }
  validates :details, length: { maximum: 1000 }
end
