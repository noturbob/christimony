require "test_helper"

class VerificationTest < ActiveSupport::TestCase
  def setup
    @account = Account.create!(email: "test@example.com", password: "password123", account_type: "individual")
  end

  test "valid with a recognized type and status" do
    verification = Verification.new(account: @account, verification_type: "phone_otp", status: "pending")
    assert verification.valid?
  end

  test "invalid with an unrecognized type" do
    verification = Verification.new(account: @account, verification_type: "fingerprint", status: "pending")
    assert_not verification.valid?
  end

  test "mark_verified! sets status and verified_at" do
    verification = Verification.create!(account: @account, verification_type: "phone_otp", status: "pending")
    verification.mark_verified!

    assert_equal "verified", verification.status
    assert_not_nil verification.verified_at
  end
end