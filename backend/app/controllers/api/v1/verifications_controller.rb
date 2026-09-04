module Api
  module V1
    class VerificationsController < BaseController
      before_action :authenticate_account!

      def index
        render json: current_account.verifications.map { |v| verification_json(v) }
      end

      def create
        verification = current_account.verifications.new(
          verification_type: params[:verification_type],
          status: "pending"
        )

        if verification.save
          render json: verification_json(verification), status: :created
        else
          render json: { errors: verification.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def verification_json(verification)
        {
          id: verification.id,
          verification_type: verification.verification_type,
          status: verification.status,
          verified_at: verification.verified_at
        }
      end
    end
  end
end