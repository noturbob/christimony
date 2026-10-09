module Api
  module V1
    class DevicesController < BaseController
      before_action :authenticate_account!

      # Upsert by token: a phone that signs into another account moves its
      # token there, so the previous account stops getting its pushes.
      def create
        device = Device.find_or_initialize_by(token: params.require(:token))
        device.update!(account: current_account, platform: params[:platform])
        render json: { id: device.id }, status: :created
      end
    end
  end
end
