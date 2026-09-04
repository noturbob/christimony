require "test_helper"

class ProfileAccessTest < ActiveSupport::TestCase
  def setup
    @account = Account.create!(email: "test@example.com", password: "password123", account_type: "individual")
    @profile = Profile.create!(name: "Test", profile_type: "self", status: "active")
  end

  test "valid with a recognized role" do
    access = ProfileAccess.new(profile: @profile, account: @account, role: "owner")
    assert access.valid?
  end

  test "invalid with an unrecognized role" do
    access = ProfileAccess.new(profile: @profile, account: @account, role: "admin")
    assert_not access.valid?
  end

  test "the same account cannot have two access rows on the same profile" do
    ProfileAccess.create!(profile: @profile, account: @account, role: "owner")
    dup = ProfileAccess.new(profile: @profile, account: @account, role: "co_pilot")
    assert_not dup.valid?
  end
end