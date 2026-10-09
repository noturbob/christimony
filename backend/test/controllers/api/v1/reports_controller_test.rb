require "test_helper"

class Api::V1::ReportsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @me = create_account
    @other_profile = create_profile(create_account, "Other")
  end

  test "creates a report without blocking" do
    post "/api/v1/reports", params: { reported_profile_id: @other_profile.id, reason: "spam", details: "ads" }, headers: auth(@me), as: :json
    assert_response :created
    report = Report.find(response.parsed_body["id"])
    assert_equal [ @me, @other_profile, "spam", "ads" ], [ report.reporter_account, report.reported_profile, report.reason, report.details ]
    assert_equal 0, Block.count
  end

  test "rejects an unknown reason or overlong details" do
    post "/api/v1/reports", params: { reported_profile_id: @other_profile.id, reason: "meh" }, headers: auth(@me), as: :json
    assert_response :unprocessable_entity
    post "/api/v1/reports", params: { reported_profile_id: @other_profile.id, reason: "other", details: "x" * 1001 }, headers: auth(@me), as: :json
    assert_response :unprocessable_entity
  end

  test "404 for a missing profile" do
    post "/api/v1/reports", params: { reported_profile_id: 0, reason: "spam" }, headers: auth(@me), as: :json
    assert_response :not_found
  end
end
