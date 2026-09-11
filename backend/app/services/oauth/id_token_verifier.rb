module Oauth
  # Shared RS256 ID-token verification for providers that publish a JWKS
  # endpoint (Google, Apple). Verifies signature, issuer, audience and
  # expiry server-side -- the frontend hands us only the raw token, never
  # an email/uid we'd otherwise have to trust blindly.
  class IdTokenVerifier
    JWKS_CACHE_TTL = 6.hours

    def initialize(jwks_url:, issuers:, audience:)
      @jwks_url = jwks_url
      @issuers = Array(issuers)
      @audience = audience
    end

    def verify(id_token)
      raise Oauth::VerificationError, "missing id_token" if id_token.blank?
      raise Oauth::VerificationError, "sign-in is not configured" if @audience.blank?

      payload, = JWT.decode(
        id_token, nil, true,
        algorithms: ["RS256"],
        jwks: jwks_loader,
        verify_iss: true, iss: @issuers,
        verify_aud: true, aud: @audience
      )
      payload
    rescue JWT::DecodeError => e
      raise Oauth::VerificationError, e.message
    end

    private

    # ruby-jwt calls this once with the decoded header; if the kid isn't in
    # our cached set it calls again with invalidate: true so a provider key
    # rotation doesn't leave us stuck on a stale cache.
    def jwks_loader
      lambda do |options|
        keys = fetch_jwks(force: options[:invalidate])
        { keys: keys }
      end
    end

    def fetch_jwks(force: false)
      Rails.cache.fetch(cache_key, expires_in: JWKS_CACHE_TTL, force: force) do
        fetch_jwks_json.fetch("keys")
      end
    end

    def fetch_jwks_json
      uri = URI.parse(@jwks_url)
      response = Net::HTTP.start(uri.host, uri.port, use_ssl: true, open_timeout: 5, read_timeout: 5) do |http|
        http.get(uri.request_uri)
      end
      raise Oauth::VerificationError, "could not reach sign-in provider" unless response.is_a?(Net::HTTPSuccess)

      JSON.parse(response.body)
    rescue SocketError, Timeout::Error, JSON::ParserError
      raise Oauth::VerificationError, "could not reach sign-in provider"
    end

    def cache_key
      "oauth/jwks/#{@jwks_url}"
    end
  end
end
