require "test_helper"

class VouchTest < ActiveSupport::TestCase
  def setup
    @profile = Profile.create!(name: "Test", profile_type: "self", status: "active")
  end

  test "valid with a recognized voucher_role" do
    vouch = Vouch.new(profile: @profile, voucher_name: "Pastor John", voucher_role: "pastor", status: "pending")
    assert vouch.valid?
  end

  test "invalid with an unrecognized voucher_role" do
    vouch = Vouch.new(profile: @profile, voucher_name: "John", voucher_role: "stranger", status: "pending")
    assert_not vouch.valid?
  end

  test "invalid without a voucher_name" do
    vouch = Vouch.new(profile: @profile, voucher_role: "pastor", status: "pending")
    assert_not vouch.valid?
  end
end