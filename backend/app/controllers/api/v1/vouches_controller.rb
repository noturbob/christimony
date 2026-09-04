module Api
  module V1
    class VouchesController < BaseController
      before_action :authenticate_account!
      before_action :set_profile

      def index
        render json: @profile.vouches.map { |v| vouch_json(v) }
      end

      def create
        vouch = @profile.vouches.new(
          voucher_name: params[:voucher_name],
          voucher_role: params[:voucher_role],
          status: "pending"
        )

        if vouch.save
          render json: vouch_json(vouch), status: :created
        else
          render json: { errors: vouch.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def set_profile
        @profile = Profile.find_by(id: params[:profile_id])
        render json: { error: "Profile not found" }, status: :not_found unless @profile
      end

      def vouch_json(vouch)
        {
          id: vouch.id,
          profile_id: vouch.profile_id,
          voucher_name: vouch.voucher_name,
          voucher_role: vouch.voucher_role,
          status: vouch.status
        }
      end
    end
  end
end