require "test_helper"

class ProfileTest < ActiveSupport::TestCase
  test "valid with required fields" do
    profile = Profile.new(name: "Test", profile_type: "self", status: "active")
    assert profile.valid?
  end

  test "invalid without a name" do
    profile = Profile.new(profile_type: "self", status: "active")
    assert_not profile.valid?
  end

  test "invalid with an unrecognized profile_type" do
    profile = Profile.new(name: "Test", profile_type: "robot", status: "active")
    assert_not profile.valid?
  end

  test "invalid with an unrecognized status" do
    profile = Profile.new(name: "Test", profile_type: "self", status: "deleted")
    assert_not profile.valid?
  end

  test "denomination is optional" do
    profile = Profile.new(name: "Test", profile_type: "self", status: "active", denomination: nil)
    assert profile.valid?
  end

  test "profile_photos are ordered by position" do
    profile = Profile.create!(name: "Test", profile_type: "self", status: "active")
    ProfilePhoto.create!(profile: profile, url: "photo1.jpg", position: 1)
    ProfilePhoto.create!(profile: profile, url: "photo0.jpg", position: 0)

    assert_equal ["photo0.jpg", "photo1.jpg"], profile.profile_photos.map(&:url)
  end
end