require "test_helper"

class Api::V1::PassesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @me, @my_profile = account_with_profile("9876588001", "Me")
    @other, @other_profile = account_with_profile("9876588002", "Other")
  end

  test "a pass hides the profile from the feed, and undo brings it back" do
    assert_includes feed_ids, @other_profile.id

    post "/api/v1/passes", params: { profile_id: @my_profile.id, passed_profile_id: @other_profile.id },
      headers: auth(@me), as: :json
    assert_response :created
    pass_id = JSON.parse(response.body)["id"]
    assert_not_includes feed_ids, @other_profile.id

    delete "/api/v1/passes/#{pass_id}", headers: auth(@me)
    assert_response :no_content
    assert_includes feed_ids, @other_profile.id
  end

  test "passing twice is idempotent" do
    2.times do
      post "/api/v1/passes", params: { profile_id: @my_profile.id, passed_profile_id: @other_profile.id },
        headers: auth(@me), as: :json
      assert_response :created
    end
    assert_equal 1, ProfilePass.count
  end

  test "cannot pass as a profile you don't manage" do
    post "/api/v1/passes", params: { profile_id: @other_profile.id, passed_profile_id: @my_profile.id },
      headers: auth(@me), as: :json
    assert_response :not_found
    assert_equal 0, ProfilePass.count
  end

  test "cannot undo someone else's pass" do
    pass = ProfilePass.create!(profile: @other_profile, passed_profile: @my_profile)

    delete "/api/v1/passes/#{pass.id}", headers: auth(@me)
    assert_response :not_found
    assert ProfilePass.exists?(pass.id)
  end

  private

  def account_with_profile(phone, name)
    account = Account.create!(phone: phone, account_type: "individual", phone_verified_at: Time.current)
    profile = Profile.create!(name: name, profile_type: "self", status: "active")
    ProfileAccess.create!(account: account, profile: profile, role: "owner")
    [ account, profile ]
  end

  def auth(account)
    { "Authorization" => "Bearer #{JsonWebToken.encode(account_id: account.id)}" }
  end

  def feed_ids
    get "/api/v1/profiles/feed", headers: auth(@me)
    JSON.parse(response.body)["profiles"].map { |p| p["id"] }
  end
end
