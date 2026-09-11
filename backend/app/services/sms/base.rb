module Sms
  class Base
    def deliver(to:, body:)
      raise NotImplementedError, "#{self.class} must implement #deliver"
    end
  end
end
