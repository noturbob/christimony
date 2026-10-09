class ProfilePhoto < ApplicationRecord
  CONTENT_TYPES = %w[image/jpeg image/png image/webp image/heic image/heif].freeze
  MAX_BYTES = 10.megabytes

  belongs_to :profile
  has_one_attached :image

  validates :position, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validate :must_have_image_or_url
  validate :image_type_and_size

  private

  def must_have_image_or_url
    unless image.attached? || url.present?
      errors.add(:base, "must have an uploaded image or a url")
    end
  end

  def image_type_and_size
    return unless image.attached?

    errors.add(:image, "must be a JPEG, PNG, WebP or HEIC image") unless image.content_type.in?(CONTENT_TYPES)
    errors.add(:image, "must be 10 MB or smaller") if image.byte_size > MAX_BYTES
  end
end
