module Api
  module V1
    class ProfilePhotosController < BaseController
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
         def profile_json(profile)
          {
            id: profile.id,
            name: profile.name,
            profile_type: profile.profile_type,
            dob: profile.dob,
            gender: profile.gender,
            city: profile.city,
            education: profile.education,
            profession: profile.profession,
            bio: profile.bio,
            status: profile.status,
            denomination: profile.denomination&.name,
            photos: profile.profile_photos.map { |p|
              { id: p.id, url: p.image.attached? ? rails_blob_url(p.image, host: request.base_url) : p.url, position: p.position }
            }
          }
        end
    end
  end
end