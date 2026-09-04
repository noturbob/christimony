module Api
  module V1
    class RegistrationsController < BaseController
      def create
        account = Account.new(account_params)

        if account.save
          token = JsonWebToken.encode(account_id: account.id)
          render json: { token: token, account: { id: account.id, email: account.email } }, status: :created
        else
          render json: { errors: account.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def account_params
        params.require(:account).permit(:email, :phone, :password, :account_type)
      end
    end
  end
end