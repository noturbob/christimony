module Api
  module V1
    # Public: the app checks this before sign-in to force an upgrade.
    class ConfigController < BaseController
      def show
        render json: { min_supported_build: ENV.fetch("MIN_SUPPORTED_BUILD", 0).to_i }
      end
    end
  end
end
