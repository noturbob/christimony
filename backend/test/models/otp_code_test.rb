require "test_helper"

class OtpCodeTest < ActiveSupport::TestCase
  test "issue! returns a record and a 6-digit code" do
    record, code = OtpCode.issue!(phone: "+919876500001")
    assert_equal 6, code.length
    assert_match(/\A\d{6}\z/, code)
    assert_equal "+919876500001", record.phone
    assert_not record.consumed_at
  end

  test "issue! invalidates prior unconsumed codes for the same phone" do
    first, _code = OtpCode.issue!(phone: "+919876500002")
    OtpCode.issue!(phone: "+919876500002")

    assert first.reload.consumed_at.present?
  end

  test "verify succeeds with the correct code" do
    _record, code = OtpCode.issue!(phone: "+919876500003")
    success, reason = OtpCode.verify(phone: "+919876500003", code: code)

    assert success
    assert_nil reason
  end

  test "verify fails with an incorrect code" do
    OtpCode.issue!(phone: "+919876500004")
    success, reason = OtpCode.verify(phone: "+919876500004", code: "000000")

    assert_not success
    assert_equal :incorrect, reason
  end

  test "verify fails once expired" do
    record, code = OtpCode.issue!(phone: "+919876500005")
    record.update!(expires_at: 1.minute.ago)

    success, reason = OtpCode.verify(phone: "+919876500005", code: code)

    assert_not success
    assert_equal :expired, reason
  end

  test "locks out after MAX_ATTEMPTS incorrect tries" do
    _record, code = OtpCode.issue!(phone: "+919876500006")

    OtpCode::MAX_ATTEMPTS.times do
      OtpCode.verify(phone: "+919876500006", code: "000000")
    end

    success, reason = OtpCode.verify(phone: "+919876500006", code: code)
    assert_not success
    assert_equal :locked, reason
  end

  test "a consumed code cannot be reused" do
    _record, code = OtpCode.issue!(phone: "+919876500007")
    OtpCode.verify(phone: "+919876500007", code: code)

    success, reason = OtpCode.verify(phone: "+919876500007", code: code)
    assert_not success
    assert_equal :not_found, reason
  end
end
