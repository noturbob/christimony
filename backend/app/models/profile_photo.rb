class ProfilePhoto < ApplicationRecord
  belongs_to :profile

  validates :url, presence: true
  validates :position, presence: true, numericality: { greater_than_or_equal_to: 0 }
end