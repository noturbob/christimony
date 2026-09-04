require "test_helper"

class IntroductionTest < ActiveSupport::TestCase
  def setup
    @parent_a = Profile.create!(name: "Parent A", profile_type: "self", status: "active")
    @parent_b = Profile.create!(name: "Parent B", profile_type: "self", status: "active")
    @ward_a = Profile.create!(name: "Ward A", profile_type: "ward", status: "active")
    @ward_b = Profile.create!(name: "Ward B", profile_type: "ward", status: "active")

    @parent_match = Match.create!(
      profile_a: @parent_a,
      profile_b: @parent_b,
      match_type: "parent",
      matched_at: Time.current
    )

    @introduction = Introduction.create!(
      parent_match: @parent_match,
      ward_a: @ward_a,
      ward_b: @ward_b,
      status: "pending_both"
    )
  end

  test "starts in pending_both status" do
    assert_equal "pending_both", @introduction.status
  end

  test "moves to pending_b when ward_a accepts first" do
    @introduction.accept!(@ward_a)
    assert_equal "pending_b", @introduction.status
  end

  test "moves to pending_a when ward_b accepts first" do
    @introduction.accept!(@ward_b)
    assert_equal "pending_a", @introduction.status
  end

  test "becomes accepted once both wards accept, regardless of order" do
    @introduction.accept!(@ward_a)
    @introduction.accept!(@ward_b)
    assert_equal "accepted", @introduction.status
  end

  test "creates a real Match between the two wards only after both accept" do
    assert_no_difference "Match.count" do
      @introduction.accept!(@ward_a)
    end

    assert_difference "Match.count", 1 do
      @introduction.accept!(@ward_b)
    end

    ward_match = Match.where(match_type: "direct").last
    assert_equal @ward_a.id, ward_match.profile_a_id
    assert_equal @ward_b.id, ward_match.profile_b_id
  end

  test "decline sets status to declined" do
    @introduction.decline!(@ward_a)
    assert_equal "declined", @introduction.status
  end

  test "raises if a profile not part of the introduction tries to accept" do
    stranger = Profile.create!(name: "Stranger", profile_type: "ward", status: "active")

    assert_raises(ArgumentError) do
      @introduction.accept!(stranger)
    end
  end
end