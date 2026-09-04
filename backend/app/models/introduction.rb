class Introduction < ApplicationRecord
  belongs_to :parent_match, class_name: "Match"
  belongs_to :ward_a, class_name: "Profile"
  belongs_to :ward_b, class_name: "Profile"

  validates :status, presence: true, inclusion: {
    in: %w[pending_both pending_a pending_b accepted declined]
  }

  def accept!(ward)
    if ward.id == ward_a_id
      advance_status(accepted_side: :a)
    elsif ward.id == ward_b_id
      advance_status(accepted_side: :b)
    else
      raise ArgumentError, "this profile is not part of this introduction"
    end
  end

  def decline!(ward)
    unless ward.id == ward_a_id || ward.id == ward_b_id
      raise ArgumentError, "this profile is not part of this introduction"
    end

    update!(status: "declined")
  end

  private

  def advance_status(accepted_side:)
    case status
    when "pending_both"
      update!(status: accepted_side == :a ? "pending_b" : "pending_a")
    when "pending_a"
      update!(status: "accepted") if accepted_side == :a
    when "pending_b"
      update!(status: "accepted") if accepted_side == :b
    end

    create_ward_match! if status == "accepted"
  end

  def create_ward_match!
    Match.create!(
      profile_a: ward_a,
      profile_b: ward_b,
      match_type: "direct",
      matched_at: Time.current
    )
  end
end