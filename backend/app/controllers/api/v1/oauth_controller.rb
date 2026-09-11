module Api
  module V1
    class OauthController < BaseController
      # POST /api/v1/auth/google
      # POST /api/v1/auth/apple
      # Body: { id_token }
      # Verifies the provider-signed identity token server-side and finds
      # or creates an account for that (provider, uid) pair. Same response
      # shape as phone OTP verify, so the frontend doesn't special-case
      # which sign-in method was used.
      def google
        authenticate_with(Oauth::GoogleVerifier, "google")
      end

      def apple
        authenticate_with(Oauth::AppleVerifier, "apple")
      end

      private

      def authenticate_with(verifier, provider)
        identity = verifier.verify(params[:id_token])
        account = find_or_create_account(provider, identity)

        token = JsonWebToken.encode(account_id: account[:record].id)
        active_profile = account[:record].profiles.find_by(status: "active")

        render json: {
          token: token,
          account: account_json(account[:record]),
          is_new_account: account[:is_new],
          onboarding: { complete: active_profile.present?, profile_id: active_profile&.id }
        }, status: :ok
      rescue Oauth::VerificationError => e
        render json: { error: e.message.presence || "Could not verify sign-in" }, status: :unauthorized
      rescue ActiveRecord::RecordInvalid => e
        render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
      end

      def find_or_create_account(provider, identity)
        existing = Account.find_by(oauth_provider: provider, oauth_uid: identity[:uid])
        return { record: existing, is_new: false } if existing

        record = Account.new(oauth_provider: provider, oauth_uid: identity[:uid], account_type: "individual")
        # Only claim the email if no other account already has it -- OAuth
        # email uniqueness isn't guaranteed across providers, so we'd
        # rather sign the person in without it than fail the whole flow.
        if identity[:email].present? && Account.find_by(email: identity[:email]).nil?
          record.email = identity[:email]
        end
        record.save!
        { record: record, is_new: true }
      end

      # Same shape as AccountsController#me / PhoneAuthController#verify.
      def account_json(account)
        {
          id: account.id,
          email: account.email,
          phone: account.phone,
          phone_verified_at: account.phone_verified_at,
          account_type: account.account_type
        }
      end
    end
  end
end
