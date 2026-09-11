require "test_helper"

class Api::V1::MessagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @account_a = Account.create!(phone: "9876566001", account_type: "individual", phone_verified_at: Time.current)
    @account_b = Account.create!(phone: "9876566002", account_type: "individual", phone_verified_at: Time.current)
    @account_c = Account.create!(phone: "9876566003", account_type: "individual", phone_verified_at: Time.current)

    @profile_a = create_profile(@account_a, "A")
    @profile_b = create_profile(@account_b, "B")
    @profile_c = create_profile(@account_c, "C")

    @match = Match.create!(profile_a: @profile_a, profile_b: @profile_b, match_type: "direct", matched_at: Time.current)
    @conversation = Conversation.create!(match: @match)
    Message.create!(conversation: @conversation, sender_account: @account_a, body: "hi")
  end

  test "a participant can read the conversation's messages" do
    get "/api/v1/conversations/#{@conversation.id}/messages", headers: auth_headers(@account_a)
    assert_response :success
  end

  test "a non-participant cannot read the conversation's messages (regression: was previously world-readable)" do
    get "/api/v1/conversations/#{@conversation.id}/messages", headers: auth_headers(@account_c)
    assert_response :forbidden
  end

  private

  def create_profile(account, name)
    profile = Profile.create!(name: name, profile_type: "self", status: "active")
    ProfileAccess.create!(profile: profile, account: account, role: "owner", activated_at: Time.current)
    profile
  end

  def auth_headers(account)
    { "Authorization" => "Bearer #{JsonWebToken.encode(account_id: account.id)}" }
  end
end
