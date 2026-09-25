module Api
  module V1
    class ConversationsController < BaseController
      include ProfileSerialization

      before_action :authenticate_account!

      def index
        my_profile_ids = current_account.profiles.pluck(:id)

        photos = { profile_photos: { image_attachment: :blob } }
        conversations = Conversation.joins(:match)
                                     .where("matches.profile_a_id IN (?) OR matches.profile_b_id IN (?)", my_profile_ids, my_profile_ids)
                                     .includes(match: { profile_a: photos, profile_b: photos })
                                     .to_a

        # One query each instead of two per conversation -- the app polls
        # this endpoint for the unread badge.
        ids = conversations.map(&:id)
        last_messages = Message.where(conversation_id: ids)
                               .select("DISTINCT ON (conversation_id) *")
                               .order(:conversation_id, sent_at: :desc)
                               .index_by(&:conversation_id)
        unread_counts = Message.where(conversation_id: ids, read_at: nil)
                               .where.not(sender_account_id: current_account.id)
                               .group(:conversation_id).count

        render json: conversations.map { |c|
          conversation_json(c, my_profile_ids, last_messages[c.id], unread_counts.fetch(c.id, 0))
        }
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

      def conversation_json(conversation, my_profile_ids,
                            last_message = conversation.messages.order(sent_at: :desc).first,
                            unread_count = conversation.messages.where(read_at: nil).where.not(sender_account_id: current_account.id).count)
        other_profile = my_profile_ids.include?(conversation.profile_a_id) ? conversation.profile_b : conversation.profile_a

        {
          id: conversation.id,
          match_id: conversation.match_id,
          other_profile: profile_summary(other_profile),
          last_message: last_message && { body: last_message.body, sent_at: last_message.sent_at },
          unread_count: unread_count
        }
      end
    end
  end
end
