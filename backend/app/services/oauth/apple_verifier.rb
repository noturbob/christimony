module Oauth
  module AppleVerifier
    ISSUER = "https://appleid.apple.com".freeze
    JWKS_URL = "https://appleid.apple.com/auth/keys".freeze

    # Apple's audience is per-client-surface, not per-app: the web flow
    # (native `AppleIDAuth` JS, a Services ID) produces a token whose `aud`
    # is that Services ID, while `sign_in_with_apple` on iOS produces a
    # token whose `aud` is the app's own bundle identifier. There is no
    # single value that satisfies both, so this accepts a comma-separated
    # list -- ruby-jwt's audience check passes if the token's `aud` is
    # *any* member of the expected list (`JWT::Claims::Audience`).
    def self.verify(id_token)
      payload = Oauth::IdTokenVerifier.new(
        jwks_url: JWKS_URL,
        issuers: ISSUER,
        audience: client_ids
      ).verify(id_token)

      { uid: payload.fetch("sub"), email: payload["email"] }
    end

    def self.client_ids
      ENV.fetch("APPLE_CLIENT_IDS", "").split(",").map(&:strip).reject(&:empty?)
    end
  end
end
