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
          profile_a_id: match.profile_a_id,
          profile_b_id: match.profile_b_id,
          match_type: match.match_type,
          matched_at: match.matched_at
        }
      end
    end
  end
end