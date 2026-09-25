module Api
  module V1
    # A left-swipe. Private to the passer -- deliberately not an Interest
    # status, since GET /interests?type=received would show it to the
    # other person.
    class PassesController < BaseController
      before_action :authenticate_account!

      def create
        profile = current_account.profiles.find(params[:profile_id])
        passed = Profile.find(params[:passed_profile_id])

        # Idempotent: a retried swipe returns the existing pass.
        pass = ProfilePass.find_or_create_by!(profile: profile, passed_profile: passed)
        render json: { id: pass.id, profile_id: pass.profile_id, passed_profile_id: pass.passed_profile_id }, status: :created
      end

      # Undo.
      def destroy
        ProfilePass.where(profile_id: current_account.profiles.select(:id)).find(params[:id]).destroy!
        head :no_content
      end
    end
  end
end
