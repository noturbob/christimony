require "test_helper"

# The feed and the conversations list must cost the same number of
# queries whether they return one row or several.
class Api::V1::NPlusOneTest < ActionDispatch::IntegrationTest
  setup do
    @me = Account.create!(phone: "9876577000", account_type: "individual", phone_verified_at: Time.current)
    @my_profile = profile_for(@me, "Me")
    @headers = { "Authorization" => "Bearer #{JsonWebToken.encode(account_id: @me.id)}" }
  end

  test "feed query count does not grow with the number of profiles" do
    add_other(1)
    one = queries_for { get "/api/v1/profiles/feed", headers: @headers }
    add_other(2)
    add_other(3)
    three = queries_for { get "/api/v1/profiles/feed", headers: @headers }

    assert_equal 3, JSON.parse(response.body)["profiles"].size
    assert_equal one, three
  end

  test "conversations query count does not grow with the number of conversations" do
    add_conversation(1)
    one = queries_for { get "/api/v1/conversations", headers: @headers }
    add_conversation(2)
    add_conversation(3)
    three = queries_for { get "/api/v1/conversations", headers: @headers }

    body = JSON.parse(response.body)
    assert_equal 3, body.size
    assert_equal [ 1 ], body.map { |c| c["unread_count"] }.uniq
    assert body.all? { |c| c["last_message"]["body"] == "latest" }
    assert_equal one, three
  end

  private

  def profile_for(account, name)
    profile = Profile.create!(name: name, profile_type: "self", status: "active")
    ProfileAccess.create!(account: account, profile: profile, role: "owner")
    profile.profile_prompts.create!(question: "Q", answer: "A")
    profile
  end

  def add_other(n)
    other = Account.create!(phone: "98765771#{n.to_s.rjust(2, '0')}", account_type: "individual", phone_verified_at: Time.current)
    [ other, profile_for(other, "Other #{n}") ]
  end

  def add_conversation(n)
    other, other_profile = add_other(n)
    match = Match.create!(profile_a: @my_profile, profile_b: other_profile, match_type: "direct", matched_at: Time.current)
    conversation = Conversation.create!(match: match)
    Message.create!(conversation: conversation, sender_account: @me, body: "first", sent_at: 2.minutes.ago)
    Message.create!(conversation: conversation, sender_account: other, body: "latest", sent_at: 1.minute.ago)
  end

  def queries_for(&block)
    count = 0
    counter = ->(*, payload) { count += 1 unless payload[:name] == "SCHEMA" || payload[:cached] }
    ActiveSupport::Notifications.subscribed(counter, "sql.active_record", &block)
    count
  end
end
