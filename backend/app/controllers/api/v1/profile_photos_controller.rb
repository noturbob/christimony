module Api
  module V1
    class ProfilePhotosController < BaseController
      include ProfileSerialization

      before_action :authenticate_account!
      before_action :set_profile
      before_action :authorize_access!

      def create
        next_position = (@profile.profile_photos.maximum(:position) || -1) + 1

        photo = @profile.profile_photos.new(position: next_position)
        photo.image.attach(params[:image])

        if photo.save
          render json: photo_json(photo), status: :created
        else
          render json: { errors: photo.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        photo = @profile.profile_photos.find_by(id: params[:id])
        return render json: { error: "Photo not found" }, status: :not_found unless photo

        photo.destroy
        head :no_content
      end

      # PATCH /api/v1/profiles/:profile_id/photos/reorder
      # Body: { order: [photo_id, photo_id, ...] }
      def reorder
        order = Array(params[:order]).map(&:to_i)
        photos = @profile.profile_photos.where(id: order).index_by(&:id)

        unless order.size == photos.size
          return render json: { error: "order must include every photo id exactly once" }, status: :unprocessable_entity
        end

        ActiveRecord::Base.transaction do
          order.each_with_index { |id, index| photos[id].update!(position: index) }
        end

        render json: @profile.reload.profile_photos.map { |p| photo_json(p) }
      end

      private

      def set_profile
        @profile = Profile.find_by(id: params[:profile_id])
        render json: { error: "Profile not found" }, status: :not_found unless @profile
      end

      def authorize_access!
        return unless @profile

        has_access = current_account.profile_accesses.exists?(profile_id: @profile.id)
        render json: { error: "Forbidden" }, status: :forbidden unless has_access
      end
    end
  end
end
