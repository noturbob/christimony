class JsonWebToken
  SECRET_KEY = Rails.application.secret_key_base

  def self.encode(payload, exp = 30.days.from_now)
    JWT.encode(payload.merge(jti: SecureRandom.uuid, exp: exp.to_i), SECRET_KEY)
  end

  # nil for an invalid, expired or revoked token. Tokens issued before jti
  # existed still decode; they just can't be revoked.
  def self.decode(token)
    decoded = HashWithIndifferentAccess.new(JWT.decode(token, SECRET_KEY)[0])
    decoded unless decoded[:jti] && RevokedToken.exists?(jti: decoded[:jti])
  rescue JWT::DecodeError
    nil
  end
end
