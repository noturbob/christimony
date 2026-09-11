module Api
  module V1
    class AccountsController < BaseController
      before_action :authenticate_account!

      def me
        active_profile = current_account.profiles.find_by(status: "active")

        render json: {
          id: current_account.id,
          email: current_account.email,
          phone: current_account.phone,
          phone_verified_at: current_account.phone_verified_at,
          account_type: current_account.account_type,
          onboarding: {
            complete: active_profile.present?,
            profile_id: active_profile&.id
          }
        }
      end
    end
  end
end
