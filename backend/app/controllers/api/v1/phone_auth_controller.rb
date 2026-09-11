module Api
  module V1
    class PhoneAuthController < BaseController
      RATE_LIMIT_WINDOW = 1.hour
      RATE_LIMIT_MAX = 5

      # POST /api/v1/auth/phone/start
      # Body: { phone }
      # Issues and sends a 6-digit OTP. Never reveals whether an account
      # already exists for this phone number.
      def start
        phone = normalize(params[:phone])
        return render_invalid_phone unless phone

        if rate_limited?(phone)
          return render json: { error: "Too many requests. Try again later." }, status: :too_many_requests
        end

        if recently_sent?(phone)
          return render json: { error: "Please wait before requesting another code." }, status: :too_many_requests
        end

        _record, code = OtpCode.issue!(phone: phone, purpose: "login")
        Sms::Adapter.current.deliver(to: phone, body: "Your Christimony verification code is #{code}. It expires in 5 minutes.")

        response = { sent: true, expires_in: OtpCode::EXPIRY.to_i, retry_after: OtpCode::RESEND_COOLDOWN.to_i }
        response[:dev_code] = code if Rails.env.development?

        render json: response, status: :ok
      end

      # POST /api/v1/auth/phone/verify
      # Body: { phone, code }
      def verify
        phone = normalize(params[:phone])
        return render_invalid_phone unless phone

        success, reason = OtpCode.verify(phone: phone, purpose: "login", code: params[:code].to_s)

        unless success
          return render json: { error: verify_error_message(reason) }, status: :unprocessable_entity
        end

        account = Account.find_or_initialize_by(phone: phone)
        is_new_account = account.new_record?
        account.account_type ||= "individual"
        account.phone_verified_at = Time.current
        account.save!

        ensure_phone_verification_record!(account)

        token = JsonWebToken.encode(account_id: account.id)
        active_profile = account.profiles.find_by(status: "active")

        render json: {
          token: token,
          account: {
            id: account.id,
            phone: account.phone,
            email: account.email,
            account_type: account.account_type,
            phone_verified_at: account.phone_verified_at
          },
          is_new_account: is_new_account,
          onboarding: {
            complete: active_profile.present?,
            profile_id: active_profile&.id
          }
        }, status: :ok
      end

      private

      def normalize(raw_phone)
        return nil if raw_phone.blank?

        parsed = Phonelib.parse(raw_phone, "IN")
        parsed.valid? ? parsed.e164 : nil
      end

      def render_invalid_phone
        render json: { error: "Enter a valid phone number" }, status: :unprocessable_entity
      end

      def rate_limited?(phone)
        OtpCode.where(phone: phone, created_at: RATE_LIMIT_WINDOW.ago..).count >= RATE_LIMIT_MAX
      end

      def recently_sent?(phone)
        last = OtpCode.where(phone: phone).order(created_at: :desc).first
        last && last.last_sent_at && last.last_sent_at > OtpCode::RESEND_COOLDOWN.ago
      end

      def verify_error_message(reason)
        case reason
        when :expired then "That code has expired. Request a new one."
        when :locked then "Too many incorrect attempts. Request a new code."
        when :incorrect then "That code isn't right. Try again."
        else "We couldn't verify that code. Request a new one."
        end
      end

      def ensure_phone_verification_record!(account)
        return if account.verifications.exists?(verification_type: "phone_otp", status: "verified")

        account.verifications.create!(
          verification_type: "phone_otp",
          status: "verified",
          verified_at: Time.current
        )
      end
    end
  end
end
