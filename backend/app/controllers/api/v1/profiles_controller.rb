module Api
  module V1
    class ProfilesController < BaseController
      before_action :authenticate_account!
      before_action :set_profile, only: [:show, :update]
      before_action :authorize_access!, only: [:update]

      def index
        profiles = current_account.profiles
        render json: profiles.map { |p| profile_json(p) }
      end

      def show
        render json: profile_json(@profile)
      end

      def create
        profile = Profile.new(profile_params)

        if profile.save
          ProfileAccess.create!(
            profile: profile,
            account: current_account,
            role: "owner",
            activated_at: Time.current
          )
          render json: profile_json(profile), status: :created
        else
          render json: { errors: profile.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @profile.update(profile_params)
          render json: profile_json(@profile)
        else
          render json: { errors: @profile.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def set_profile
        @profile = Profile.find_by(id: params[:id])
        render json: { error: "Profile not found" }, status: :not_found unless @profile
      end

      def authorize_access!
        return unless @profile

        has_access = current_account.profile_accesses.exists?(profile_id: @profile.id)
        render json: { error: "Forbidden" }, status: :forbidden unless has_access
      end

      def profile_params
        params.require(:profile).permit(
          :denomination_id, :profile_type, :name, :dob, :gender,
          :city, :education, :profession, :bio, :status
        )
      end

      def profile_json(profile)
        {
          id: profile.id,
          name: profile.name,
          profile_type: profile.profile_type,
          dob: profile.dob,
          gender: profile.gender,
          city: profile.city,
          education: profile.education,
          profession: profile.profession,
          bio: profile.bio,
          status: profile.status,
          denomination: profile.denomination&.name
        }
      end
    end
  end
end