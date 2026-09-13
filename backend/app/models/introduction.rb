class Introduction < ApplicationRecord
  belongs_to :parent_match, class_name: "Match"
  belongs_to :ward_a, class_name: "Profile"
  belongs_to :ward_b, class_name: "Profile"

  validates :status, presence: true, inclusion: {
    in: %w[pending_both pending_a pending_b accepted declined]
  }

  # Both accept! and decline! are idempotent no-ops once the introduction
  # is resolved (accepted or declined) -- a repeat call (client retry,
  # double-tap, stale UI) must never re-run the side effect. Before this
  # guard, calling accept! again on an already-"accepted" introduction fell
  # through advance_status's `case status` with no matching branch (there
  # was no `when "accepted"`), leaving status unchanged at "accepted" --
  # but the create_ward_match! call right after the case block only checks
  # the CURRENT status, not whether this call caused a transition, so it
  # fired again anyway and created a duplicate Match every time.
  def accept!(ward)
    unless ward.id == ward_a_id || ward.id == ward_b_id
      raise ArgumentError, "this profile is not part of this introduction"
    end

    return if resolved?

    if ward.id == ward_a_id
      advance_status(accepted_side: :a)
    else
      advance_status(accepted_side: :b)
    end
  end

  def decline!(ward)
    unless ward.id == ward_a_id || ward.id == ward_b_id
      raise ArgumentError, "this profile is not part of this introduction"
    end

    # Also stops a decline from ever landing on an already-"accepted"
    # introduction, which would desync its status from the real Match
    # that accepting it already created.
    return if resolved?

    update!(status: "declined")
  end

  private

  def resolved?
    status.in?(%w[accepted declined])
  end

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
