class Profile < ApplicationRecord
  belongs_to :denomination, optional: true

  has_many :profile_accesses, dependent: :delete_all
  has_many :accounts, through: :profile_accesses
  has_many :vouches, dependent: :delete_all
  has_many :profile_photos, -> { order(:position) }, dependent: :destroy
  has_many :profile_prompts, -> { order(:created_at) }, dependent: :delete_all
  has_many :sent_interests, class_name: "Interest", foreign_key: :sender_profile_id, dependent: :delete_all
  has_many :received_interests, class_name: "Interest", foreign_key: :receiver_profile_id, dependent: :delete_all
  has_many :passes, class_name: "ProfilePass", dependent: :delete_all
  has_many :passed_by, class_name: "ProfilePass", foreign_key: :passed_profile_id, dependent: :delete_all
  has_many :introductions_as_ward_a, class_name: "Introduction", foreign_key: :ward_a_id, dependent: :delete_all
  has_many :introductions_as_ward_b, class_name: "Introduction", foreign_key: :ward_b_id, dependent: :delete_all
  has_many :matches_as_a, class_name: "Match", foreign_key: :profile_a_id, dependent: :destroy
  has_many :matches_as_b, class_name: "Match", foreign_key: :profile_b_id, dependent: :destroy
  has_many :blocks_against, class_name: "Block", foreign_key: :blocked_profile_id, dependent: :delete_all
  has_many :reports_against, class_name: "Report", foreign_key: :reported_profile_id, dependent: :delete_all

  validates :name, presence: true
  validates :profile_type, presence: true, inclusion: { in: %w[self ward] }
  # "draft" lets the onboarding wizard create a profile early (photos and
  # prompts need a profile_id to attach to) without it appearing in
  # anyone's feed until the wizard's final step flips it to "active".
  validates :status, presence: true, inclusion: { in: %w[draft active paused banned] }
  validates :gender, inclusion: { in: %w[male female] }, allow_nil: true

  scope :discoverable, -> { where(status: "active") }

  def age
    return nil unless dob

    now = Date.current
    now.year - dob.year - ((now.month > dob.month || (now.month == dob.month && now.day >= dob.day)) ? 0 : 1)
  end
end
