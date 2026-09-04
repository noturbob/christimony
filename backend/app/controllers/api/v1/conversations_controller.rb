module Api
  module V1
    class ConversationsController < BaseController
      before_action :authenticate_account!

      def index
        my_profile_ids = current_account.profiles.pluck(:id)

        conversations = Conversation.joins(:match)
                                     .where("matches.profile_a_id IN (?) OR matches.profile_b_id IN (?)", my_profile_ids, my_profile_ids)

        render json: conversations.map { |c| conversation_json(c) }
      end

      def create
        match = Match.find_by(id: params[:match_id])
        my_profile_ids = current_account.profiles.pluck(:id)

        unless match && (my_profile_ids.include?(match.profile_a_id) || my_profile_ids.include?(match.profile_b_id))
          return render json: { error: "You do not have access to that match" }, status: :forbidden
        end

        conversation = Conversation.find_or_create_by!(match: match)
        render json: conversation_json(conversation), status: :created
      end

      private

      def conversation_json(conversation)
        {
          id: conversation.id,
          match_id: conversation.match_id,
          profile_a_id: conversation.profile_a_id,
          profile_b_id: conversation.profile_b_id
        }
      end
    end
  end
end