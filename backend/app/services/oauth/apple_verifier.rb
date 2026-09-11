module Oauth
  module AppleVerifier
    ISSUER = "https://appleid.apple.com".freeze
    JWKS_URL = "https://appleid.apple.com/auth/keys".freeze

    def self.verify(id_token)
      payload = Oauth::IdTokenVerifier.new(
        jwks_url: JWKS_URL,
        issuers: ISSUER,
        audience: ENV["APPLE_CLIENT_ID"]
      ).verify(id_token)

      { uid: payload.fetch("sub"), email: payload["email"] }
    end
  end
end
