module Api
  module V1
    class ProfilePromptsController < BaseController
      include ProfileSerialization

      before_action :authenticate_account!
      before_action :set_profile
      before_action :authorize_access!, only: [:create, :update, :destroy]
      before_action :set_prompt, only: [:update, :destroy]

      def index
        render json: @profile.profile_prompts.map { |p| prompt_json(p) }
      end

      def create
        prompt = @profile.profile_prompts.new(prompt_params)

        if prompt.save
          render json: prompt_json(prompt), status: :created
        else
          render json: { errors: prompt.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @prompt.update(prompt_params)
          render json: prompt_json(@prompt)
        else
          render json: { errors: @prompt.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @prompt.destroy
        head :no_content
      end

      private

      def set_profile
        @profile = Profile.find_by(id: params[:profile_id])
        render json: { error: "Profile not found" }, status: :not_found unless @profile
      end

      def set_prompt
        return unless @profile

        @prompt = @profile.profile_prompts.find_by(id: params[:id])
        render json: { error: "Prompt not found" }, status: :not_found unless @prompt
      end

      def authorize_access!
        return unless @profile

        has_access = current_account.profile_accesses.exists?(profile_id: @profile.id)
        render json: { error: "Forbidden" }, status: :forbidden unless has_access
      end

      def prompt_params
        params.require(:prompt).permit(:question, :answer)
      end
    end
  end
end
