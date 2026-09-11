module Api
  module V1
    class SessionsController < BaseController
      def create
        account = find_account

        if account&.authenticate(params[:password])
          token = JsonWebToken.encode(account_id: account.id)
          render json: { token: token, account: account_json(account) }, status: :ok
        else
          render json: { error: "Invalid email/phone or password" }, status: :unauthorized
        end
      end

      private

      def find_account
        if params[:email].present?
          Account.find_by(email: params[:email])
        elsif params[:phone].present?
          Account.find_by(phone: params[:phone])
        end
      end

      # Same shape as AccountsController#me / RegistrationsController#create.
      def account_json(account)
        active_profile = account.profiles.find_by(status: "active")

        {
          id: account.id,
          email: account.email,
          phone: account.phone,
          phone_verified_at: account.phone_verified_at,
          account_type: account.account_type,
          onboarding: { complete: active_profile.present?, profile_id: active_profile&.id }
        }
      end
    end
  end
end
