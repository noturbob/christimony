module Sms
  # Selects the SMS provider from ENV["SMS_PROVIDER"] ("log" | "twilio" | "msg91"),
  # defaulting to the safe no-op logger so local dev never needs real SMS.
  module Adapter
    ADAPTERS = {
      "log" => Sms::LogAdapter,
      "twilio" => Sms::TwilioAdapter,
      "msg91" => Sms::Msg91Adapter
    }.freeze

    def self.current
      klass = ADAPTERS.fetch(ENV.fetch("SMS_PROVIDER", "log"), Sms::LogAdapter)
      klass.new
    end
  end
end
