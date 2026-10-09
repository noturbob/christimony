require "net/http"

# FCM HTTP v1. Configured by FCM_PROJECT_ID + FCM_CREDENTIALS_JSON (a
# service-account key); every call is a no-op without them.
module Fcm
  SCOPE = "https://www.googleapis.com/auth/firebase.messaging".freeze

  module_function

  def configured?
    ENV["FCM_PROJECT_ID"].present? && ENV["FCM_CREDENTIALS_JSON"].present?
  end

  # Returns :ok, :unregistered (the token is dead and should be dropped)
  # or :failed. Never raises for an HTTP error so one bad token doesn't
  # stop delivery to the rest.
  def deliver(token, title:, body:, data:)
    message = { token: token, notification: { title: title, body: body }.compact, data: data.to_h { |k, v| [ k.to_s, v.to_s ] } }
    response = Net::HTTP.post(
      URI("https://fcm.googleapis.com/v1/projects/#{ENV.fetch('FCM_PROJECT_ID')}/messages:send"),
      { message: message }.to_json,
      "Authorization" => "Bearer #{access_token}", "Content-Type" => "application/json"
    )
    return :ok if response.is_a?(Net::HTTPSuccess)
    return :unregistered if response.body.to_s.include?("UNREGISTERED")

    Rails.logger.warn("FCM send failed: #{response.code} #{response.body}")
    :failed
  end

  def access_token
    return @access_token if @access_token && @access_token_expires_at > Time.current

    credentials = JSON.parse(ENV.fetch("FCM_CREDENTIALS_JSON"))
    token_uri = credentials.fetch("token_uri", "https://oauth2.googleapis.com/token")
    now = Time.current.to_i
    assertion = JWT.encode(
      { iss: credentials.fetch("client_email"), scope: SCOPE, aud: token_uri, iat: now, exp: now + 3600 },
      OpenSSL::PKey::RSA.new(credentials.fetch("private_key")), "RS256"
    )
    response = Net::HTTP.post_form(URI(token_uri), grant_type: "urn:ietf:params:oauth:grant-type:jwt-bearer", assertion: assertion)
    body = JSON.parse(response.body)
    raise "FCM auth failed: #{body}" unless response.is_a?(Net::HTTPSuccess)

    @access_token_expires_at = Time.current + body.fetch("expires_in").to_i - 60
    @access_token = body.fetch("access_token")
  end
end
