module Api
  module V1
    class InterestsController < BaseController
      before_action :authenticate_account!

      def index
        my_profile_ids = current_account.profiles.pluck(:id)
        column = params[:type] == "sent" ? :sender_profile_id : :receiver_profile_id

        interests = Interest.where(column => my_profile_ids)
        render json: interests.map { |i| interest_json(i) }
      end

      def create
        sender_profile = Profile.find_by(id: params[:sender_profile_id])
        receiver_profile = Profile.find_by(id: params[:receiver_profile_id])

        unless sender_profile && current_account.profile_accesses.exists?(profile_id: sender_profile.id)
          return render json: { error: "You do not have access to the sending profile" }, status: :forbidden
        end

        unless receiver_profile
          return render json: { error: "Receiver profile not found" }, status: :not_found
        end

        interest = Interest.new(sender_profile: sender_profile, receiver_profile: receiver_profile, status: "pending")

        if interest.save
          match = check_for_mutual_match(interest)
          render json: { interest: interest_json(interest), match: match && match_json(match) }, status: :created
        else
          render json: { errors: interest.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def check_for_mutual_match(interest)
        reciprocal = Interest.find_by(
          sender_profile_id: interest.receiver_profile_id,
          receiver_profile_id: interest.sender_profile_id,
          status: "pending"
        )
        return nil unless reciprocal

        interest.update!(status: "accepted")
        reciprocal.update!(status: "accepted")

        match = Match.create!(
          profile_a: interest.sender_profile,
          profile_b: interest.receiver_profile,
          match_type: determine_match_type(interest.sender_profile, interest.receiver_profile),
          matched_at: Time.current
        )

        create_introduction_if_parent_match(match)
        match
      end

      def create_introduction_if_parent_match(match)
        return unless match.match_type == "parent"

        ward_a = find_ward_for(match.profile_a)
        ward_b = find_ward_for(match.profile_b)
        return unless ward_a && ward_b

        Introduction.create!(
          parent_match: match,
          ward_a: ward_a,
          ward_b: ward_b,
          status: "pending_both"
        )
      end

      def find_ward_for(profile)
        owner_access = ProfileAccess.find_by(profile_id: profile.id, role: "owner")
        return nil unless owner_access

        Profile.joins(:profile_accesses)
               .where(profile_accesses: { account_id: owner_access.account_id })
               .find_by(profile_type: "ward")
      end

      def determine_match_type(profile_a, profile_b)
        parent_owned?(profile_a) && parent_owned?(profile_b) ? "parent" : "direct"
      end

      def parent_owned?(profile)
        owner_access = ProfileAccess.find_by(profile_id: profile.id, role: "owner")
        owner_access&.account&.account_type == "parent"
      end

      def interest_json(interest)
        {
          id: interest.id,
          sender_profile_id: interest.sender_profile_id,
          receiver_profile_id: interest.receiver_profile_id,
          status: interest.status
        }
      end

      def match_json(match)
        {
          id: match.id,
          profile_a_id: match.profile_a_id,
          profile_b_id: match.profile_b_id,
          match_type: match.match_type
        }
      end
    end
  end
end