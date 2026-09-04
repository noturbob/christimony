require "test_helper"

class InterestTest < ActiveSupport::TestCase
  def setup
    @profile_a = Profile.create!(name: "A", profile_type: "self", status: "active")
    @profile_b = Profile.create!(name: "B", profile_type: "self", status: "active")
  end

  test "valid interest between two different profiles" do
    interest = Interest.new(sender_profile: @profile_a, receiver_profile: @profile_b, status: "pending")
    assert interest.valid?
  end

  test "cannot send an interest to yourself" do
    interest = Interest.new(sender_profile: @profile_a, receiver_profile: @profile_a, status: "pending")
    assert_not interest.valid?
    assert_includes interest.errors.full_messages, "cannot send an interest to yourself"
  end

  test "cannot send a duplicate interest to the same profile" do
    Interest.create!(sender_profile: @profile_a, receiver_profile: @profile_b, status: "pending")
    dup = Interest.new(sender_profile: @profile_a, receiver_profile: @profile_b, status: "pending")
    assert_not dup.valid?
  end
end