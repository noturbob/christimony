module Sms
  # Development/test fallback: never sends a real SMS. Logs the message so
  # a developer can read the OTP code from the Rails log, and (only in
  # development) hands the code back to the controller so it can be
  # surfaced in a dev-only banner in the frontend without needing a real
  # phone.
  class LogAdapter < Base
    def deliver(to:, body:)
      Rails.logger.info("[Sms::LogAdapter] to=#{to} body=#{body}")
      true
    end
  end
end
