require "test_helper"

class Api::V1::SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @account = create_account
    @headers = auth(@account)
  end

  test "tokens carry a jti" do
    assert JsonWebToken.decode(@headers["Authorization"].split.last)[:jti].present?
  end

  test "refresh issues a new token and revokes the presented one" do
    post "/api/v1/auth/refresh", headers: @headers
    assert_response :success
    new_token = response.parsed_body["token"]

    get "/api/v1/me", headers: { "Authorization" => "Bearer #{new_token}" }
    assert_response :success

    get "/api/v1/me", headers: @headers
    assert_response :unauthorized

    post "/api/v1/auth/refresh", headers: @headers
    assert_response :unauthorized
  end

  test "refresh rejects an invalid token" do
    post "/api/v1/auth/refresh", headers: { "Authorization" => "Bearer garbage" }
    assert_response :unauthorized
  end

  test "logout revokes the token and deletes only the caller's named device" do
    mine = @account.devices.create!(token: "mine", platform: "android")
    other = create_account.devices.create!(token: "theirs", platform: "ios")

    delete "/api/v1/auth/session", params: { device_token: "mine" }, headers: @headers, as: :json
    assert_response :no_content
    assert_not Device.exists?(mine.id)

    delete "/api/v1/auth/session", params: { device_token: "theirs" }, headers: auth(@account), as: :json
    assert Device.exists?(other.id)

    get "/api/v1/me", headers: @headers
    assert_response :unauthorized
  end
end
