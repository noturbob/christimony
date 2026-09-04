require "test_helper"

class MatchTest < ActiveSupport::TestCase
  def setup
    @profile_a = Profile.create!(name: "A", profile_type: "self", status: "active")
    @profile_b = Profile.create!(name: "B", profile_type: "self", status: "active")
  end

  test "valid with a recognized match_type" do
    match = Match.new(profile_a: @profile_a, profile_b: @profile_b, match_type: "direct", matched_at: Time.current)
    assert match.valid?
  end

  test "invalid with an unrecognized match_type" do
    match = Match.new(profile_a: @profile_a, profile_b: @profile_b, match_type: "arranged", matched_at: Time.current)
    assert_not match.valid?
  end

  test "invalid without matched_at" do
    match = Match.new(profile_a: @profile_a, profile_b: @profile_b, match_type: "direct")
    assert_not match.valid?
  end
end