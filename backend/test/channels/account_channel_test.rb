require "test_helper"

class AccountChannelTest < ActionCable::Channel::TestCase
  setup do
    @a = create_account
    @b = create_account
    @profile_a = create_profile(@a, "A")
    @profile_b = create_profile(@b, "B")
  end

  test "streams for the connected account" do
    stub_connection current_account: @a
    subscribe
    assert subscription.confirmed?
    assert_has_stream_for @a
  end

  test "a match is broadcast to both sides" do
    match = nil
    assert_broadcasts(AccountChannel.broadcasting_for(@a), 1) do
      assert_broadcasts(AccountChannel.broadcasting_for(@b), 1) do
        match = Match.create!(profile_a: @profile_a, profile_b: @profile_b, match_type: "direct", matched_at: Time.current)
      end
    end
    assert_broadcast_on(AccountChannel.broadcasting_for(@b), { type: "match", match_id: match.id })
  end

  test "an introduction is broadcast on create and on status change" do
    ward_a = create_profile(@a, "Ward A", profile_type: "ward")
    ward_b = create_profile(@b, "Ward B", profile_type: "ward")
    match = Match.create!(profile_a: @profile_a, profile_b: @profile_b, match_type: "parent", matched_at: Time.current)

    intro = Introduction.create!(parent_match: match, ward_a: ward_a, ward_b: ward_b)
    assert_broadcast_on(AccountChannel.broadcasting_for(@b), { type: "introduction", introduction_id: intro.id, status: "pending_both" })

    intro.decline!(ward_a)
    assert_broadcast_on(AccountChannel.broadcasting_for(@a), { type: "introduction", introduction_id: intro.id, status: "declined" })
  end
end
