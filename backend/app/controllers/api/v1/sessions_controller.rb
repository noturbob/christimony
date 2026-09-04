module Api
  module V1
    class SessionsController < BaseController
      def create
        account = find_account

        if account&.authenticate(params[:password])
          token = JsonWebToken.encode(account_id: account.id)
          render json: { token: token, account: { id: account.id, email: account.email } }, status: :ok
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
    end
  end
end