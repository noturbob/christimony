class OtpCode < ApplicationRecord
  MAX_ATTEMPTS = 5
  EXPIRY = 5.minutes
  RESEND_COOLDOWN = 30.seconds

  validates :phone, presence: true
  validates :code_digest, presence: true
  validates :purpose, presence: true
  validates :expires_at, presence: true

  class << self
    # Generates a new 6-digit code for `phone`, invalidates any prior
    # unconsumed codes for that phone+purpose, and returns the OtpCode.
    # The raw code is only available via the return value of `issue!` --
    # it is never persisted or logged outside of the Sms adapter layer.
    def issue!(phone:, purpose: "login")
      active_for(phone, purpose).update_all(consumed_at: Time.current)

      code = format("%06d", SecureRandom.random_number(1_000_000))
      record = create!(
        phone: phone,
        code_digest: BCrypt::Password.create(code),
        purpose: purpose,
        expires_at: EXPIRY.from_now,
        last_sent_at: Time.current
      )

      [ record, code ]
    end

    def active_for(phone, purpose)
      where(phone: phone, purpose: purpose, consumed_at: nil)
    end

    # Returns true/false without raising; callers should check `errors`
    # (a symbol reason) when it returns false.
    def verify(phone:, purpose: "login", code:)
      record = active_for(phone, purpose).order(created_at: :desc).first
      return [ false, :not_found ] unless record

      record.verify(code)
    end
  end

  def expired?
    expires_at < Time.current
  end

  def locked?
    attempts >= MAX_ATTEMPTS
  end

  # Returns [success_boolean, reason_symbol_or_nil]
  def verify(code)
    return [ false, :locked ] if locked?
    return [ false, :expired ] if expired?

    increment!(:attempts)

    if BCrypt::Password.new(code_digest) == code.to_s
      update!(consumed_at: Time.current)
      [ true, nil ]
    else
      [ false, :incorrect ]
    end
  end
end
