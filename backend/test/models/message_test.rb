require "test_helper"

class MessageTest < ActiveSupport::TestCase
  def setup
    @account_a = Account.create!(email: "a@example.com", password: "password123", account_type: "individual")
    @account_b = Account.create!(email: "b@example.com", password: "password123", account_type: "individual")
    @stranger = Account.create!(email: "stranger@example.com", password: "password123", account_type: "individual")

    @profile_a = Profile.create!(name: "A", profile_type: "self", status: "active")
    @profile_b = Profile.create!(name: "B", profile_type: "self", status: "active")

    ProfileAccess.create!(profile: @profile_a, account: @account_a, role: "owner")
    ProfileAccess.create!(profile: @profile_b, account: @account_b, role: "owner")

    @match = Match.create!(profile_a: @profile_a, profile_b: @profile_b, match_type: "direct", matched_at: Time.current)
    @conversation = Conversation.create!(match: @match)
  end

  test "a participant can send a message" do
    message = Message.new(conversation: @conversation, sender_account: @account_a, body: "Hello!")
    assert message.save
  end

  test "a non-participant cannot send a message" do
    message = Message.new(conversation: @conversation, sender_account: @stranger, body: "I shouldn't be here")
    assert_not message.save
    assert_includes message.errors.full_messages, "sender does not have access to a profile in this conversation"
  end

  test "sent_at is automatically set if not provided" do
    message = Message.create!(conversation: @conversation, sender_account: @account_a, body: "Hi")
    assert_not_nil message.sent_at
  end

  test "body cannot be blank" do
    message = Message.new(conversation: @conversation, sender_account: @account_a, body: "")
    assert_not message.valid?
  end
end