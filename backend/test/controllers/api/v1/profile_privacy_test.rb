require "test_helper"

class Api::V1::ProfilePrivacyTest < ActionDispatch::IntegrationTest
  setup do
    @owner = create_account
    @draft = create_profile(@owner, "Draft", status: "draft")
    @stranger = create_account
  end

  test "a non-active profile, its prompts and vouches are 404 to strangers" do
    [ "", "/prompts", "/vouches" ].each do |suffix|
      get "/api/v1/profiles/#{@draft.id}#{suffix}", headers: auth(@stranger)
      assert_response :not_found, suffix

      get "/api/v1/profiles/#{@draft.id}#{suffix}", headers: auth(@owner)
      assert_response :success, suffix
    end
  end

  test "an active profile is visible to strangers" do
    @draft.update!(status: "active")
    get "/api/v1/profiles/#{@draft.id}/prompts", headers: auth(@stranger)
    assert_response :success
  end
end
