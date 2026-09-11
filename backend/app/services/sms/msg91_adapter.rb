require "net/http"
require "json"

module Sms
  # Drop-in alternative to Twilio for Indian transactional SMS, where a
  # DLT-registered sender + template is effectively mandatory. Configure
  # MSG91_AUTH_KEY and MSG91_TEMPLATE_ID (and register the OTP template
  # with "##OTP##" as the variable) in the Msg91 dashboard.
  class Msg91Adapter < Base
    ENDPOINT = "https://control.msg91.com/api/v5/otp".freeze

    def deliver(to:, body:)
      otp = body[/\d{6}/]
      uri = URI(ENDPOINT)
      uri.query = URI.encode_www_form(
        template_id: ENV.fetch("MSG91_TEMPLATE_ID"),
        mobile: to.delete_prefix("+"),
        authkey: ENV.fetch("MSG91_AUTH_KEY"),
        otp: otp
      )

      response = Net::HTTP.get_response(uri)
      response.is_a?(Net::HTTPSuccess)
    rescue StandardError => e
      Rails.logger.error("[Sms::Msg91Adapter] failed to=#{to} error=#{e.message}")
      false
    end
  end
end
