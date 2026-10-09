class RevokedToken < ApplicationRecord
  def self.revoke!(payload)
    return if payload[:jti].blank?

    insert({ jti: payload[:jti], expires_at: Time.zone.at(payload[:exp]) }, unique_by: :jti)
  end
end
