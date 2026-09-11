module Api
  module V1
    class RegistrationsController < BaseController
      def create
        account = Account.new(account_params)

        if account.save
          token = JsonWebToken.encode(account_id: account.id)
          render json: { token: token, account: account_json(account) }, status: :created
        else
          render json: { errors: account.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def account_params
        params.require(:account).permit(:email, :phone, :password, :account_type)
      end

      # Same shape as AccountsController#me -- every auth entry point
      # (signup, login, phone verify) returns an identical Account payload
      # so the frontend never has to special-case which flow it came from.
      def account_json(account)
        {
          id: account.id,
          email: account.email,
          phone: account.phone,
          phone_verified_at: account.phone_verified_at,
          account_type: account.account_type,
          onboarding: { complete: false, profile_id: nil }
        }
      end
    end
  end
end
