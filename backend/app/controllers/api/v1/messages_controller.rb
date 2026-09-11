module Api
  module V1
    class MessagesController < BaseController
      before_action :authenticate_account!
      before_action :set_conversation
      before_action :authorize_access!

      def index
        @conversation.messages.where(read_at: nil).where.not(sender_account_id: current_account.id)
                     .update_all(read_at: Time.current)

        render json: @conversation.messages.order(:sent_at).map { |m| message_json(m) }
      end

      def create
        message = @conversation.messages.new(
          sender_account: current_account,
          body: params[:body]
        )

        if message.save
          render json: message_json(message), status: :created
        else
          render json: { errors: message.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def set_conversation
        @conversation = Conversation.find_by(id: params[:conversation_id])
        render json: { error: "Conversation not found" }, status: :not_found unless @conversation
      end

      # Bug fix: previously any authenticated account could read any
      # conversation's messages regardless of participation.
      def authorize_access!
        return unless @conversation

        my_profile_ids = current_account.profiles.pluck(:id)
        participant_ids = [@conversation.profile_a_id, @conversation.profile_b_id]

        unless (my_profile_ids & participant_ids).any?
          render json: { error: "Forbidden" }, status: :forbidden
        end
      end

      def message_json(message)
        {
          id: message.id,
          conversation_id: message.conversation_id,
          sender_account_id: message.sender_account_id,
          body: message.body,
          sent_at: message.sent_at,
          read_at: message.read_at
        }
      end
    end
  end
end
