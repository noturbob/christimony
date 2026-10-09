module Api
  module V1
    class SessionsController < BaseController
      rate_limit to: 30, within: 1.hour, only: :refresh, with: :rate_limited
      before_action :authenticate_account!

      # POST /api/v1/auth/refresh
      def refresh
        RevokedToken.revoke!(token_payload)
        render json: { token: JsonWebToken.encode(account_id: current_account.id) }
      end

      # DELETE /api/v1/auth/session
      def destroy
        RevokedToken.revoke!(token_payload)
        current_account.devices.where(token: params[:device_token]).delete_all if params[:device_token].present?
        head :no_content
      end
    end
  end
end
