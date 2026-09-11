module Api
  module V1
    class DenominationsController < BaseController
      # No auth required -- needed unauthenticated on the onboarding wizard
      # and marketing pages.
      def index
        denominations = Denomination.order(:name)
        render json: denominations.map { |d| { id: d.id, name: d.name } }
      end
    end
  end
end
