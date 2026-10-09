require "test_helper"

class Api::V1::BlocksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @me = create_account
    @my_profile = create_profile(@me, "Me")
    @other = create_account
    @other_profile = create_profile(@other, "Other")
  end

  test "block, list, unblock" do
    2.times do
      post "/api/v1/blocks", params: { blocked_profile_id: @other_profile.id }, headers: auth(@me), as: :json
      assert_response :created
    end
    assert_equal 1, Block.count
    block_id = response.parsed_body["id"]
    assert_equal @other_profile.id, response.parsed_body["blocked_profile"]["id"]

    get "/api/v1/blocks", headers: auth(@me)
    assert_equal [ block_id ], response.parsed_body.map { |b| b["id"] }
    assert response.parsed_body.first["created_at"].present?

    delete "/api/v1/blocks/#{block_id}", headers: auth(@me)
    assert_response :no_content
    assert_equal 0, Block.count
  end

  test "cannot block a profile you manage" do
    post "/api/v1/blocks", params: { blocked_profile_id: @my_profile.id }, headers: auth(@me), as: :json
    assert_response :unprocessable_entity
    assert response.parsed_body["errors"].present?
  end

  test "cannot unblock someone else's block" do
    block = @other.blocks.create!(blocked_profile: @my_profile)
    delete "/api/v1/blocks/#{block.id}", headers: auth(@me)
    assert_response :not_found
    assert Block.exists?(block.id)
  end

  test "a block hides profiles in both directions" do
    match = Match.create!(profile_a: @my_profile, profile_b: @other_profile, match_type: "direct", matched_at: Time.current)
    Conversation.create!(match: match)
    @other.blocks.create!(blocked_profile: @my_profile)

    [ [ @me, @other_profile ], [ @other, @my_profile ] ].each do |viewer, target|
      get "/api/v1/profiles/feed", headers: auth(viewer)
      assert_not_includes response.parsed_body["profiles"].map { |p| p["id"] }, target.id

      get "/api/v1/profiles/#{target.id}", headers: auth(viewer)
      assert_response :not_found

      get "/api/v1/matches", headers: auth(viewer)
      assert_empty response.parsed_body

      get "/api/v1/conversations", headers: auth(viewer)
      assert_empty response.parsed_body

      sender = viewer.profiles.first
      post "/api/v1/interests", params: { sender_profile_id: sender.id, receiver_profile_id: target.id }, headers: auth(viewer), as: :json
      assert_response :forbidden
    end
  end

  test "a block on one managed profile hides every profile the blocker manages" do
    ward = create_profile(@other, "Other ward", profile_type: "ward")
    @other.blocks.create!(blocked_profile: @my_profile)

    get "/api/v1/profiles/#{ward.id}", headers: auth(@me)
    assert_response :not_found
  end
end
