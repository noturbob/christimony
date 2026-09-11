module Api
  module V1
    class ProfilesController < BaseController
      include ProfileSerialization

      before_action :authenticate_account!
      before_action :set_profile, only: [:show, :update]
      before_action :authorize_access!, only: [:update]

      MAX_PER_PAGE = 25

      def index
        profiles = current_account.profiles
        render json: profiles.map { |p| profile_json(p) }
      end

      def feed
        my_profile_ids = current_account.profiles.pluck(:id)
        already_interested_ids = Interest.where(sender_profile_id: my_profile_ids).pluck(:receiver_profile_id)

        profiles = Profile.discoverable
                           .where.not(id: my_profile_ids + already_interested_ids)

        profiles = profiles.where(city: params[:city]) if params[:city].present?
        profiles = profiles.where(denomination_id: params[:denomination_id]) if params[:denomination_id].present?
        profiles = profiles.where(gender: params[:gender]) if params[:gender].present?
        profiles = apply_age_filter(profiles)

        per = params[:per].present? ? [params[:per].to_i, MAX_PER_PAGE].min : MAX_PER_PAGE
        per = MAX_PER_PAGE if per < 1
        page = [params[:page].to_i, 1].max

        profiles = profiles.order(:id).offset((page - 1) * per).limit(per + 1)
        results = profiles.to_a
        has_more = results.size > per
        results = results.first(per)

        render json: {
          profiles: results.map { |p| profile_json(p) },
          next_page: has_more ? page + 1 : nil
        }
      end

      def show
        render json: profile_json(@profile)
      end

      def create
        # Always create as "draft" regardless of what's in profile_params --
        # the DB column defaults to "active", so a plain `||=` never fires.
        # Activation happens through a later `update` (the onboarding
        # wizard's final step), never at creation time.
        profile = Profile.new(profile_params.except(:status))
        profile.status = "draft"

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

      def apply_age_filter(scope)
        return scope unless params[:min_age].present? || params[:max_age].present?

        today = Date.current
        if params[:max_age].present?
          earliest_dob = today << (params[:max_age].to_i * 12 + 12)
          scope = scope.where("dob >= ?", earliest_dob)
        end
        if params[:min_age].present?
          latest_dob = today << (params[:min_age].to_i * 12)
          scope = scope.where("dob <= ?", latest_dob)
        end
        scope
      end

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
    end
  end
end
