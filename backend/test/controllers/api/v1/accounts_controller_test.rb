require "test_helper"

class Api::V1::AccountsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @account = create_account
  end

  test "PATCH /me changes account_type and returns the /me shape" do
    patch "/api/v1/me", params: { account_type: "parent" }, headers: auth(@account), as: :json
    assert_response :success
    assert_equal "parent", response.parsed_body["account_type"]
    assert response.parsed_body.key?("onboarding")
    assert_equal "parent", @account.reload.account_type
  end

  test "PATCH /me rejects an invalid account_type" do
    patch "/api/v1/me", params: { account_type: "admin" }, headers: auth(@account), as: :json
    assert_response :unprocessable_entity
    assert response.parsed_body["errors"].present?
  end

  test "DELETE /me requires auth" do
    delete "/api/v1/me"
    assert_response :unauthorized
  end

  test "DELETE /me removes the account's whole graph and leaves the other party intact" do
    parent = create_account(account_type: "parent")
    own = create_profile(parent, "Parent")
    ward = create_profile(parent, "Ward", profile_type: "ward")
    own.profile_photos.create!(url: "https://example.com/a.jpg", position: 0)
    own.profile_prompts.create!(question: "Q", answer: "A")
    own.vouches.create!(voucher_name: "Pastor", voucher_role: "pastor")
    parent.verifications.create!(verification_type: "phone_otp", status: "verified")
    parent.subscriptions.create!(plan: "free")
    parent.devices.create!(token: "t1", platform: "android")

    other = create_account(account_type: "parent")
    other_profile = create_profile(other, "Other")
    other_ward = create_profile(other, "Other ward", profile_type: "ward")
    shared = create_profile(other, "Shared")
    ProfileAccess.create!(account: parent, profile: shared, role: "co_pilot")

    Interest.create!(sender_profile: own, receiver_profile: other_profile, status: "accepted")
    Interest.create!(sender_profile: other_profile, receiver_profile: own, status: "accepted")
    match = Match.create!(profile_a: own, profile_b: other_profile, match_type: "parent", matched_at: Time.current)
    conversation = Conversation.create!(match: match)
    Message.create!(conversation: conversation, sender_account: parent, body: "hi")
    Message.create!(conversation: conversation, sender_account: other, body: "hello")
    Introduction.create!(parent_match: match, ward_a: ward, ward_b: other_ward)
    ProfilePass.create!(profile: ward, passed_profile: other_profile)
    ProfilePass.create!(profile: other_profile, passed_profile: ward)
    parent.blocks.create!(blocked_profile: other_ward)
    other.blocks.create!(blocked_profile: ward)
    Report.create!(reporter_account: other, reported_profile: own, reason: "spam")
    report_by_parent = Report.create!(reporter_account: parent, reported_profile: other_ward, reason: "spam")

    # A co-pilot conversation on a profile the account doesn't own.
    third = create_account
    third_profile = create_profile(third, "Third")
    co_pilot_conversation = Conversation.create!(match: Match.create!(profile_a: shared, profile_b: third_profile, match_type: "direct", matched_at: Time.current))
    Message.create!(conversation: co_pilot_conversation, sender_account: parent, body: "as co-pilot")

    delete "/api/v1/me", headers: auth(parent)
    assert_response :no_content

    assert_not Account.exists?(parent.id)
    assert_not Profile.exists?(id: [ own.id, ward.id ])
    assert_equal 0, ProfilePhoto.where(profile_id: own.id).count
    assert_equal 0, Interest.where(sender_profile_id: own.id).or(Interest.where(receiver_profile_id: own.id)).count
    assert_not Match.exists?(match.id)
    assert_not Conversation.exists?(conversation.id)
    assert_equal 0, Introduction.count
    assert_equal 0, ProfilePass.count
    assert_equal 0, Block.count
    assert_equal 0, Device.count
    assert_equal 0, Verification.where(account_id: parent.id).count
    assert_equal 0, Subscription.where(account_id: parent.id).count
    assert_equal 0, ProfileAccess.where(account_id: parent.id).count
    assert_equal 0, Message.where(sender_account_id: parent.id).count
    assert_nil report_by_parent.reload.reporter_account_id
    assert_not Report.exists?(reported_profile_id: own.id)

    assert Profile.exists?(other_profile.id)
    assert Profile.exists?(other_ward.id)
    assert Profile.exists?(shared.id)
    assert Conversation.exists?(co_pilot_conversation.id)
    assert Account.exists?(other.id)
  end
end
