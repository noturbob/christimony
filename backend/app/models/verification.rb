class Verification < ApplicationRecord
  belongs_to :account

  validates :verification_type, presence: true, inclusion: {
    in: %w[government_id selfie_liveness phone_otp email_otp video_kyc]
  }
  validates :status, presence: true, inclusion: { in: %w[pending verified rejected] }

  def mark_verified!
    update!(status: "verified", verified_at: Time.current)
  end
end