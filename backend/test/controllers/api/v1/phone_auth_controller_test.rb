require "test_helper"

class Api::V1::PhoneAuthControllerTest < ActionDispatch::IntegrationTest
  test "start issues a code and dev_code is only present in development" do
    post "/api/v1/auth/phone/start", params: { phone: "9876511111" }, as: :json
    assert_response :success

    body = JSON.parse(response.body)
    assert body["sent"]
    assert_not body.key?("dev_code"), "dev_code must never leak outside development"
  end

  test "verify creates a new account and returns a token, phone-onboarding not yet complete" do
    _record, code = OtpCode.issue!(phone: "+919876522222")

    post "/api/v1/auth/phone/verify", params: { phone: "9876522222", code: code }, as: :json
    assert_response :success

    body = JSON.parse(response.body)
    assert body["token"].present?
    assert body["is_new_account"]
    assert_equal false, body["onboarding"]["complete"]
    assert_equal "+919876522222", body["account"]["phone"]
  end

  test "verify rejects an incorrect code" do
    OtpCode.issue!(phone: "+919876533333")

    post "/api/v1/auth/phone/verify", params: { phone: "9876533333", code: "000000" }, as: :json
    assert_response :unprocessable_entity
  end

  test "verify with a valid token round-trips through /me" do
    _record, code = OtpCode.issue!(phone: "+919876544444")
    post "/api/v1/auth/phone/verify", params: { phone: "9876544444", code: code }, as: :json
    token = JSON.parse(response.body)["token"]

    get "/api/v1/me", headers: { "Authorization" => "Bearer #{token}" }
    assert_response :success
    assert_equal "+919876544444", JSON.parse(response.body)["phone"]
  end

  test "onboarding.complete becomes true once the account has an active profile" do
    _record, code = OtpCode.issue!(phone: "+919876555555")
    post "/api/v1/auth/phone/verify", params: { phone: "9876555555", code: code }, as: :json
    token = JSON.parse(response.body)["token"]

    post "/api/v1/profiles",
      params: { profile: { name: "Jane", profile_type: "self", gender: "female" } },
      headers: { "Authorization" => "Bearer #{token}" }, as: :json
    profile_id = JSON.parse(response.body)["id"]
    assert_equal "draft", JSON.parse(response.body)["status"], "profiles must be created as draft, not active"

    patch "/api/v1/profiles/#{profile_id}",
      params: { profile: { status: "active" } },
      headers: { "Authorization" => "Bearer #{token}" }, as: :json

    get "/api/v1/me", headers: { "Authorization" => "Bearer #{token}" }
    assert JSON.parse(response.body)["onboarding"]["complete"]
  end
end
