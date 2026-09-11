module Sms
  class TwilioAdapter < Base
    def initialize
      @client = Twilio::REST::Client.new(
        ENV.fetch("TWILIO_ACCOUNT_SID"),
        ENV.fetch("TWILIO_AUTH_TOKEN")
      )
      @from = ENV.fetch("TWILIO_FROM")
    end

    def deliver(to:, body:)
      @client.messages.create(from: @from, to: to, body: body)
      true
    rescue Twilio::REST::RestError => e
      Rails.logger.error("[Sms::TwilioAdapter] failed to=#{to} error=#{e.message}")
      false
    end
  end
end
