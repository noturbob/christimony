module Api
  module V1
    class MessagesController < BaseController
      before_action :authenticate_account!
      before_action :set_conversation
      before_action :authorize_access!
      rate_limit to: 60, within: 1.minute, only: :create, by: -> { current_account.id }, with: :rate_limited

      DEFAULT_LIMIT = 30
      MAX_LIMIT = 100

      # Newest `limit` messages older than `before_id`, returned oldest
      # first. Deliberately no read side effect: see ConversationsController#read.
      def index
        limit = (params[:limit].presence || DEFAULT_LIMIT).to_i.clamp(1, MAX_LIMIT)
        messages = @conversation.messages
        messages = messages.where(id: ...params[:before_id].to_i) if params[:before_id].present?

        render json: messages.order(id: :desc).limit(limit).reverse.map(&:api_json)
      end

      def create
        participant_ids = [ @conversation.profile_a_id, @conversation.profile_b_id ]
        if (participant_ids & current_account.hidden_profile_ids).any?
          return render json: { error: "You can't message this profile" }, status: :forbidden
        end

        message = @conversation.messages.new(
          sender_account: current_account,
          body: params[:body]
        )

        if message.save
          render json: message.api_json, status: :created
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
        participant_ids = [ @conversation.profile_a_id, @conversation.profile_b_id ]

        unless (my_profile_ids & participant_ids).any?
          render json: { error: "Forbidden" }, status: :forbidden
        end
      end
    end
  end
end
