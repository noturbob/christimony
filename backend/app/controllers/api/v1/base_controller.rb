module Api
  module V1
    class BaseController < ActionController::API
      # Without these, none of the three are rendered as JSON: Rails falls
      # back to its default HTML error pages (config.consider_all_requests_local
      # is true in development, so that page includes a full stack trace).
      # A missing `{"profile": {...}}` wrapper key from `params.require`, a
      # failed `.create!`/`.save!`/`.update!` (several controllers use the
      # bang form with no local rescue -- see e.g. ProfilesController#create,
      # InterestsController#accept_mutual!, PhoneAuthController#verify), or
      # a stray `.find` instead of `find_by` all hit this now instead of
      # crashing with an HTML body a JSON client can't parse.
      rescue_from ActionController::ParameterMissing do |e|
        render json: { error: e.message }, status: :bad_request
      end

      rescue_from ActiveRecord::RecordInvalid do |e|
        render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
      end

      rescue_from ActiveRecord::RecordNotFound do
        render json: { error: "Not found" }, status: :not_found
      end

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
