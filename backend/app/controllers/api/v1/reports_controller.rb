module Api
  module V1
    class ReportsController < BaseController
      before_action :authenticate_account!
      rate_limit to: 20, within: 1.day, by: -> { current_account.id }, with: :rate_limited

      def create
        report = current_account.reports.create!(
          reported_profile: Profile.find(params.require(:reported_profile_id)),
          reason: params[:reason],
          details: params[:details]
        )
        render json: { id: report.id }, status: :created
      end
    end
  end
end
