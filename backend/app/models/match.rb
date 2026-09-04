class Match < ApplicationRecord
  belongs_to :profile_a, class_name: "Profile"
  belongs_to :profile_b, class_name: "Profile"

  validates :match_type, presence: true, inclusion: { in: %w[direct parent] }
  validates :matched_at, presence: true
end