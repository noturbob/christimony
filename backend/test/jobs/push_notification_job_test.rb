require "test_helper"

class PushNotificationJobTest < ActiveJob::TestCase
  setup do
    @account = create_account
    @live = @account.devices.create!(token: "live", platform: "android")
    @dead = @account.devices.create!(token: "dead", platform: "ios")
  end

  test "is a no-op when FCM isn't configured" do
    with_fcm(configured: false, deliver: ->(*) { flunk "must not send" }) do
      PushNotificationJob.perform_now([ @account.id ], "t", "b", { type: "match", match_id: 1 })
    end
    assert_equal 2, Device.count
  end

  test "sends to each device and drops tokens FCM reports unregistered" do
    sent = []
    deliver = ->(token, **opts) { sent << [ token, opts ]; token == "dead" ? :unregistered : :ok }

    with_fcm(configured: true, deliver: deliver) do
      PushNotificationJob.perform_now([ @account.id ], "It's a match", nil, { type: "match", match_id: 7 })
    end

    assert_equal %w[dead live], sent.map(&:first).sort
    assert_equal({ title: "It's a match", body: nil, data: { type: "match", match_id: 7 } }, sent.first.last)
    assert Device.exists?(@live.id)
    assert_not Device.exists?(@dead.id)
  end

  private

  # Minitest 6 has no Object#stub; swap the singleton methods directly.
  def with_fcm(configured:, deliver:)
    original_configured = Fcm.method(:configured?)
    original_deliver = Fcm.method(:deliver)
    Fcm.define_singleton_method(:configured?) { configured }
    Fcm.define_singleton_method(:deliver, &deliver)
    yield
  ensure
    Fcm.define_singleton_method(:configured?, original_configured)
    Fcm.define_singleton_method(:deliver, original_deliver)
  end
end
