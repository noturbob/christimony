module Api
  module V1
    class ConversationsController < BaseController
      include ProfileSerialization

      before_action :authenticate_account!

      def index
        my_profile_ids = current_account.profiles.pluck(:id)

        conversations = Conversation.joins(:match)
                                     .where("matches.profile_a_id IN (?) OR matches.profile_b_id IN (?)", my_profile_ids, my_profile_ids)

        render json: conversations.map { |c| conversation_json(c, my_profile_ids) }
      end

      def create
        match = Match.find_by(id: params[:match_id])
        my_profile_ids = current_account.profiles.pluck(:id)

        unless match && (my_profile_ids.include?(match.profile_a_id) || my_profile_ids.include?(match.profile_b_id))
          return render json: { error: "You do not have access to that match" }, status: :forbidden
        end

        conversation = Conversation.find_or_create_by!(match: match)
        render json: conversation_json(conversation, my_profile_ids), status: :created
      end

      private

      def conversation_json(conversation, my_profile_ids)
        other_profile = my_profile_ids.include?(conversation.profile_a_id) ? conversation.profile_b : conversation.profile_a
        last_message = conversation.messages.order(sent_at: :desc).first

        {
          id: conversation.id,
          match_id: conversation.match_id,
          other_profile: profile_summary(other_profile),
          last_message: last_message && { body: last_message.body, sent_at: last_message.sent_at },
          unread_count: unread_count_for(conversation, my_profile_ids)
        }
      end

      def unread_count_for(conversation, my_profile_ids)
        conversation.messages
                    .where(read_at: nil)
                    .where.not(sender_account_id: current_account.id)
                    .count
      end
    end
  end
end
