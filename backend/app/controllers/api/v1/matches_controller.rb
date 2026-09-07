module Api
  module V1
    class MatchesController < BaseController
      before_action :authenticate_account!

      def index
        my_profile_ids = current_account.profiles.pluck(:id)

        matches = Match.where(profile_a_id: my_profile_ids)
                        .or(Match.where(profile_b_id: my_profile_ids))

        render json: matches.map { |m| match_json(m) }
      end

      private

      def match_json(match)
        {
          id: match.id,
          profile_a: profile_summary(match.profile_a),
          profile_b: profile_summary(match.profile_b),
          match_type: match.match_type,
          matched_at: match.matched_at
        }
      end

      def profile_summary(profile)
        {
          id: profile.id,
          name: profile.name,
          city: profile.city,
          profile_type: profile.profile_type
        }
      end
    end
  end
end