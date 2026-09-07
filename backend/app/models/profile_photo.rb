class ProfilePhoto < ApplicationRecord
  belongs_to :profile
  has_one_attached :image

  validates :position, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validate :must_have_image_or_url

  private

  def must_have_image_or_url
    unless image.attached? || url.present?
      errors.add(:base, "must have an uploaded image or a url")
    end
  end
end