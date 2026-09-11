module Api
  module V1
    class MatchesController < BaseController
      include ProfileSerialization

      before_action :authenticate_account!

      def index
        my_profile_ids = current_account.profiles.pluck(:id)

        matches = Match.where(profile_a_id: my_profile_ids)
                        .or(Match.where(profile_b_id: my_profile_ids))

        render json: matches.map { |m| match_json(m, my_profile_ids) }
      end

      private

      def match_json(match, my_profile_ids)
        {
          id: match.id,
          profile_a: profile_summary(match.profile_a),
          profile_b: profile_summary(match.profile_b),
          # Which side is "me" -- clients shouldn't have to work this out
          # themselves from raw profile_a/profile_b ids.
          my_profile_id: my_profile_ids.include?(match.profile_a_id) ? match.profile_a_id : match.profile_b_id,
          match_type: match.match_type,
          matched_at: match.matched_at
        }
      end
    end
  end
end
