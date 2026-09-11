require "test_helper"

class Api::V1::OauthControllerTest < ActionDispatch::IntegrationTest
  # Minitest 6 dropped Object#stub into a separate gem we don't depend on,
  # so this swaps the verifier module's singleton method directly instead
  # of hitting Google/Apple's real JWKS endpoints in tests.
  def stub_verifier(mod, result)
    original = mod.method(:verify)
    mod.define_singleton_method(:verify) { |_id_token| result.is_a?(Proc) ? result.call : result }
    yield
  ensure
    mod.define_singleton_method(:verify, original)
  end

  test "google creates a new account and returns a token, onboarding not yet complete" do
    stub_verifier(Oauth::GoogleVerifier, { uid: "google-uid-1", email: "new@example.com" }) do
      post "/api/v1/auth/google", params: { id_token: "stubbed" }, as: :json
    end

    assert_response :success
    body = JSON.parse(response.body)
    assert body["token"].present?
    assert body["is_new_account"]
    assert_equal false, body["onboarding"]["complete"]
    assert_equal "new@example.com", body["account"]["email"]
  end

  test "google signs an existing account back in instead of creating a duplicate" do
    account = Account.create!(email: "existing@example.com", account_type: "individual", oauth_provider: "google", oauth_uid: "google-uid-2")

    stub_verifier(Oauth::GoogleVerifier, { uid: "google-uid-2", email: "existing@example.com" }) do
      post "/api/v1/auth/google", params: { id_token: "stubbed" }, as: :json
    end

    assert_response :success
    body = JSON.parse(response.body)
    assert_equal false, body["is_new_account"]
    assert_equal account.id, body["account"]["id"]
    assert_equal 1, Account.where(oauth_provider: "google", oauth_uid: "google-uid-2").count
  end

  test "apple creates a new account" do
    stub_verifier(Oauth::AppleVerifier, { uid: "apple-uid-1", email: "apple-user@example.com" }) do
      post "/api/v1/auth/apple", params: { id_token: "stubbed" }, as: :json
    end

    assert_response :success
    body = JSON.parse(response.body)
    assert body["is_new_account"]
    assert_equal "apple", Account.find(body["account"]["id"]).oauth_provider
  end

  test "rejects a token that fails verification" do
    stub_verifier(Oauth::GoogleVerifier, -> { raise Oauth::VerificationError, "bad token" }) do
      post "/api/v1/auth/google", params: { id_token: "garbage" }, as: :json
    end

    assert_response :unauthorized
  end

  test "does not steal an email already claimed by another account" do
    Account.create!(email: "taken@example.com", account_type: "individual", oauth_provider: "apple", oauth_uid: "apple-existing")

    stub_verifier(Oauth::GoogleVerifier, { uid: "google-uid-3", email: "taken@example.com" }) do
      post "/api/v1/auth/google", params: { id_token: "stubbed" }, as: :json
    end

    assert_response :success
    body = JSON.parse(response.body)
    assert_nil body["account"]["email"]
  end
end
