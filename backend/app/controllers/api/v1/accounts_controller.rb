module Api
  module V1
    class AccountsController < BaseController
      before_action :authenticate_account!

      def me
        render json: { id: current_account.id, email: current_account.email, account_type: current_account.account_type }
      end
    end
  end
end