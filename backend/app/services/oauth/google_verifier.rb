module Oauth
  module GoogleVerifier
    ISSUERS = ["accounts.google.com", "https://accounts.google.com"].freeze
    JWKS_URL = "https://www.googleapis.com/oauth2/v3/certs".freeze

    def self.verify(id_token)
      payload = Oauth::IdTokenVerifier.new(
        jwks_url: JWKS_URL,
        issuers: ISSUERS,
        audience: ENV["GOOGLE_CLIENT_ID"]
      ).verify(id_token)

      raise Oauth::VerificationError, "email is not verified" if payload["email"].present? && payload["email_verified"] == false

      { uid: payload.fetch("sub"), email: payload["email"] }
    end
  end
end
