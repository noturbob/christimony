module Api
  module V1
    class SubscriptionsController < BaseController
      before_action :authenticate_account!

      def index
        render json: current_account.subscriptions.map { |s| subscription_json(s) }
      end

      def create
        subscription = current_account.subscriptions.new(
          plan: params[:plan],
          status: "active"
        )

        if subscription.save
          render json: subscription_json(subscription), status: :created
        else
          render json: { errors: subscription.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def subscription_json(subscription)
        {
          id: subscription.id,
          plan: subscription.plan,
          status: subscription.status,
          started_at: subscription.started_at,
          expires_at: subscription.expires_at
        }
      end
    end
  end
end