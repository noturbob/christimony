module Api
  module V1
    class IntroductionsController < BaseController
      before_action :authenticate_account!
      before_action :set_introduction, only: [:accept, :decline]
      before_action :set_ward_profile, only: [:accept, :decline]

      def index
        my_profile_ids = current_account.profiles.pluck(:id)

        introductions = Introduction.where(ward_a_id: my_profile_ids)
                                     .or(Introduction.where(ward_b_id: my_profile_ids))

        render json: introductions.map { |i| introduction_json(i) }
      end

      def accept
        @introduction.accept!(@ward_profile)
        render json: introduction_json(@introduction.reload)
      rescue ArgumentError => e
        render json: { error: e.message }, status: :forbidden
      end

      def decline
        @introduction.decline!(@ward_profile)
        render json: introduction_json(@introduction.reload)
      rescue ArgumentError => e
        render json: { error: e.message }, status: :forbidden
      end

      private

      def set_introduction
        @introduction = Introduction.find_by(id: params[:id])
        render json: { error: "Introduction not found" }, status: :not_found unless @introduction
      end

      def set_ward_profile
        return unless @introduction

        @ward_profile = Profile.find_by(id: params[:ward_profile_id])

        unless @ward_profile && current_account.profile_accesses.exists?(profile_id: @ward_profile.id)
          render json: { error: "You do not have access to that ward profile" }, status: :forbidden
        end
      end

      def introduction_json(introduction)
        {
          id: introduction.id,
          parent_match_id: introduction.parent_match_id,
          ward_a_id: introduction.ward_a_id,
          ward_b_id: introduction.ward_b_id,
          status: introduction.status
        }
      end
    end
  end
end