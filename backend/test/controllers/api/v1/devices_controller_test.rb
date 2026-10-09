require "test_helper"

class Api::V1::DevicesControllerTest < ActionDispatch::IntegrationTest
  test "registers a device, and re-registering the token moves it to the new account" do
    first = create_account
    second = create_account

    post "/api/v1/devices", params: { token: "fcm-1", platform: "android" }, headers: auth(first), as: :json
    assert_response :created
    id = response.parsed_body["id"]

    post "/api/v1/devices", params: { token: "fcm-1", platform: "android" }, headers: auth(second), as: :json
    assert_response :created
    assert_equal id, response.parsed_body["id"]
    assert_equal second.id, Device.find(id).account_id
  end

  test "rejects an unknown platform" do
    post "/api/v1/devices", params: { token: "fcm-2", platform: "windows" }, headers: auth(create_account), as: :json
    assert_response :unprocessable_entity
  end
end
