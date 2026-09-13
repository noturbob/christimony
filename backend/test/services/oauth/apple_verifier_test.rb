require "test_helper"

class Oauth::AppleVerifierTest < ActiveSupport::TestCase
  setup do
    @key = OpenSSL::PKey::RSA.generate(2048)
    @jwk = JWT::JWK.new(@key)
    jwk_export = @jwk.export

    # Redefine the one method that hits the network so this test exercises
    # the real signature/issuer/audience verification path instead of
    # bypassing it -- test env's cache_store is :null_store, so this
    # replaces the JWKS response on every call with no cross-test leakage.
    @original_fetch_jwks_json = Oauth::IdTokenVerifier.instance_method(:fetch_jwks_json)
    Oauth::IdTokenVerifier.send(:define_method, :fetch_jwks_json) { { "keys" => [ jwk_export ] } }
  end

  teardown do
    Oauth::IdTokenVerifier.send(:define_method, :fetch_jwks_json, @original_fetch_jwks_json)
    ENV.delete("APPLE_CLIENT_IDS")
  end

  def token_for(aud:, iss: Oauth::AppleVerifier::ISSUER, sub: "apple-user-1", exp: 1.hour.from_now)
    payload = { iss: iss, aud: aud, sub: sub, exp: exp.to_i, email: "person@example.com" }
    JWT.encode(payload, @key, "RS256", kid: @jwk.kid)
  end

  test "verifies when the token's aud matches the app's bundle id, not just the web Services ID" do
    ENV["APPLE_CLIENT_IDS"] = "com.christimony.web,app.christimony"

    identity = Oauth::AppleVerifier.verify(token_for(aud: "app.christimony"))

    assert_equal "apple-user-1", identity[:uid]
    assert_equal "person@example.com", identity[:email]
  end

  test "also verifies the web Services ID audience from the same list" do
    ENV["APPLE_CLIENT_IDS"] = "com.christimony.web,app.christimony"

    identity = Oauth::AppleVerifier.verify(token_for(aud: "com.christimony.web"))

    assert_equal "apple-user-1", identity[:uid]
  end

  test "rejects an audience not in the configured list" do
    ENV["APPLE_CLIENT_IDS"] = "com.christimony.web,app.christimony"

    assert_raises(Oauth::VerificationError) do
      Oauth::AppleVerifier.verify(token_for(aud: "some.other.app"))
    end
  end

  test "raises a configuration error rather than silently accepting everything when unset" do
    ENV.delete("APPLE_CLIENT_IDS")

    assert_raises(Oauth::VerificationError) do
      Oauth::AppleVerifier.verify(token_for(aud: "app.christimony"))
    end
  end
end
