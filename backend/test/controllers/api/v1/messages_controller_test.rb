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

  test "pages backwards with before_id, oldest first within a page" do
    5.times { |i| Message.create!(conversation: @conversation, sender_account: @account_b, body: "m#{i}") }
    # 6 messages total: "hi", m0..m4

    get "/api/v1/conversations/#{@conversation.id}/messages", params: { limit: 4 }, headers: auth_headers(@account_a)
    page1 = JSON.parse(response.body)
    assert_equal %w[m1 m2 m3 m4], page1.map { |m| m["body"] }

    get "/api/v1/conversations/#{@conversation.id}/messages", params: { limit: 4, before_id: page1.first["id"] }, headers: auth_headers(@account_a)
    assert_equal %w[hi m0], JSON.parse(response.body).map { |m| m["body"] }
  end

  test "GET messages no longer marks anything read; POST read does" do
    Message.create!(conversation: @conversation, sender_account: @account_b, body: "unread")

    get "/api/v1/conversations/#{@conversation.id}/messages", headers: auth_headers(@account_a)
    assert_equal 1, @conversation.messages.where(read_at: nil).where.not(sender_account: @account_a).count

    post "/api/v1/conversations/#{@conversation.id}/read", headers: auth_headers(@account_a)
    assert_response :no_content
    assert_equal 0, @conversation.messages.where(read_at: nil).where.not(sender_account: @account_a).count
    assert_nil @conversation.messages.find_by(body: "hi").read_at, "own messages stay unread"
  end

  test "a non-participant cannot mark a conversation read" do
    post "/api/v1/conversations/#{@conversation.id}/read", headers: auth_headers(@account_c)
    assert_response :not_found
  end

  test "body over 2000 characters is rejected" do
    post "/api/v1/conversations/#{@conversation.id}/messages", params: { body: "a" * 2001 }, headers: auth_headers(@account_a), as: :json
    assert_response :unprocessable_entity
  end

  test "sending broadcasts to both sides and pushes only to the recipient" do
    assert_broadcasts(AccountChannel.broadcasting_for(@account_b), 1) do
      assert_enqueued_with(job: PushNotificationJob, args: [ [ @account_b.id ], "A", "yo", { type: "message", conversation_id: @conversation.id } ]) do
        post "/api/v1/conversations/#{@conversation.id}/messages", params: { body: "yo" }, headers: auth_headers(@account_a), as: :json
      end
    end
    assert_response :created
    event = broadcasts(AccountChannel.broadcasting_for(@account_a)).map { |b| JSON.parse(b) }.last
    assert_equal "message", event["type"]
    assert_equal "yo", event["message"]["body"]
  end

  test "cannot message across a block in either direction" do
    @account_b.blocks.create!(blocked_profile: @profile_a)

    post "/api/v1/conversations/#{@conversation.id}/messages", params: { body: "hey" }, headers: auth_headers(@account_a), as: :json
    assert_response :forbidden
    post "/api/v1/conversations/#{@conversation.id}/messages", params: { body: "hey" }, headers: auth_headers(@account_b), as: :json
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
