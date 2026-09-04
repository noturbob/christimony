module Api
  module V1
    class BaseController < ActionController::API
      private

      def current_account
        @current_account ||= authenticate_account
      end

      def authenticate_account
        header = request.headers["Authorization"]
        token = header.split(" ").last if header

        decoded = JsonWebToken.decode(token)
        Account.find_by(id: decoded[:account_id]) if decoded
      end

      def authenticate_account!
        render json: { error: "Unauthorized" }, status: :unauthorized unless current_account
      end
    end
  end
end