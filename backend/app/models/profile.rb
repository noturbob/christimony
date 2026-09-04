class Profile < ApplicationRecord
  belongs_to :denomination, optional: true

  has_many :profile_accesses
  has_many :accounts, through: :profile_accesses
  has_many :vouches
  has_many :profile_photos, -> { order(:position) }
  has_many :profile_prompts

  validates :name, presence: true
  validates :profile_type, presence: true, inclusion: { in: %w[self ward] }
  validates :status, presence: true, inclusion: { in: %w[active paused banned] }
end