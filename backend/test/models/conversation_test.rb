require "test_helper"

class ConversationTest < ActiveSupport::TestCase
  def setup
    @profile_a = Profile.create!(name: "A", profile_type: "self", status: "active")
    @profile_b = Profile.create!(name: "B", profile_type: "self", status: "active")
    @match = Match.create!(profile_a: @profile_a, profile_b: @profile_b, match_type: "direct", matched_at: Time.current)
  end

  test "valid with a match" do
    conversation = Conversation.new(match: @match)
    assert conversation.valid?
  end

  test "only one conversation allowed per match" do
    Conversation.create!(match: @match)
    dup = Conversation.new(match: @match)

    assert_raises(ActiveRecord::RecordNotUnique) do
      Conversation.insert!({ match_id: @match.id })
    end
  end

  test "delegates profile_a and profile_b to its match" do
    conversation = Conversation.create!(match: @match)
    assert_equal @profile_a, conversation.profile_a
    assert_equal @profile_b, conversation.profile_b
  end
end