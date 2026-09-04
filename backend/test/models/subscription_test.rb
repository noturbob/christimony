require "test_helper"

class SubscriptionTest < ActiveSupport::TestCase
  def setup
    @account = Account.create!(email: "test@example.com", password: "password123", account_type: "individual")
  end

  test "valid with a recognized plan and status" do
    subscription = Subscription.new(account: @account, plan: "premium", status: "active")
    assert subscription.valid?
  end

  test "started_at is set automatically if not provided" do
    subscription = Subscription.create!(account: @account, plan: "premium", status: "active")
    assert_not_nil subscription.started_at
  end

  test "cannot have two active subscriptions at once" do
    Subscription.create!(account: @account, plan: "premium", status: "active")
    second = Subscription.new(account: @account, plan: "family", status: "active")

    assert_not second.valid?
    assert_includes second.errors.full_messages, "account already has an active subscription"
  end

  test "can have an expired subscription alongside a new active one" do
    Subscription.create!(account: @account, plan: "premium", status: "expired")
    active = Subscription.new(account: @account, plan: "premium", status: "active")

    assert active.valid?
  end

  test "updating an existing active subscription does not conflict with itself" do
    subscription = Subscription.create!(account: @account, plan: "premium", status: "active")
    subscription.expires_at = 30.days.from_now

    assert subscription.valid?
  end
end