module Api
  module V1
    class BlocksController < BaseController
      include ProfileSerialization

      before_action :authenticate_account!

      def index
        blocks = current_account.blocks.includes(blocked_profile: { profile_photos: { image_attachment: :blob } }).order(:id)
        render json: blocks.map { |b| block_json(b) }
      end

      # Idempotent: blocking twice returns the existing block.
      def create
        profile = Profile.find(params.require(:blocked_profile_id))
        block = current_account.blocks.find_or_create_by!(blocked_profile: profile)
        render json: block_json(block), status: :created
      end

      def destroy
        current_account.blocks.find(params[:id]).destroy!
        head :no_content
      end

      private

      def block_json(block)
        { id: block.id, blocked_profile: profile_summary(block.blocked_profile), created_at: block.created_at }
      end
    end
  end
end
