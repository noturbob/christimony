class PushNotificationJob < ApplicationJob
  queue_as :default

  def perform(account_ids, title, body, data)
    return unless Fcm.configured?

    Device.where(account_id: account_ids).find_each do |device|
      device.destroy if Fcm.deliver(device.token, title: title, body: body, data: data) == :unregistered
    end
  end
end
