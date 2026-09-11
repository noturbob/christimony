class Profile < ApplicationRecord
  belongs_to :denomination, optional: true

  has_many :profile_accesses
  has_many :accounts, through: :profile_accesses
  has_many :vouches
  has_many :profile_photos, -> { order(:position) }
  has_many :profile_prompts, -> { order(:created_at) }

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
