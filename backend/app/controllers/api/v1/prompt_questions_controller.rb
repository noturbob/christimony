module Api
  module V1
    class PromptQuestionsController < BaseController
      QUESTIONS = [
        "A faith habit I'd love to build together…",
        "My church community would describe me as…",
        "Sunday afternoons look like…",
        "I'm looking for someone who…",
        "A verse that's shaped my life…",
        "The way to my heart is…",
        "Family means…",
        "I'll know it's right when…",
        "My friends would say my faith shows up in…",
        "A small thing I'm grateful for today…",
        "The most spontaneous thing I've done…",
        "Together, we could…"
      ].freeze

      # No auth required -- needed on the onboarding wizard before a
      # profile/account may fully exist yet.
      def index
        render json: QUESTIONS
      end
    end
  end
end
