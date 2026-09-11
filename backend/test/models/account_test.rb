require "test_helper"

class AccountTest < ActiveSupport::TestCase
  test "valid with a verified phone" do
    account = Account.new(phone: "9999999999", account_type: "individual", phone_verified_at: Time.current)
    assert account.valid?
  end

  test "valid with a connected oauth account" do
    account = Account.new(email: "test@example.com", account_type: "individual", oauth_provider: "google", oauth_uid: "abc123")
    assert account.valid?
  end

  test "invalid without email, phone, or a connected account" do
    account = Account.new(account_type: "individual", phone_verified_at: Time.current)
    assert_not account.valid?
    assert_includes account.errors.full_messages, "must provide an email, a phone number, or a connected account"
  end

  test "invalid without a recognized account_type" do
    account = Account.new(phone: "9999999999", phone_verified_at: Time.current, account_type: "robot")
    assert_not account.valid?
  end

  test "email must be unique" do
    Account.create!(email: "dup@example.com", account_type: "individual", oauth_provider: "google", oauth_uid: "dup-1")
    dup = Account.new(email: "dup@example.com", account_type: "individual", oauth_provider: "google", oauth_uid: "dup-2")
    assert_not dup.valid?
  end

  test "phone is normalized to E.164 on save" do
    account = Account.create!(phone: "9876500010", account_type: "individual", phone_verified_at: Time.current)
    assert_equal "+919876500010", account.phone
  end

  test "an account with an unverified phone and no connected account is invalid" do
    account = Account.new(phone: "9876500012", account_type: "individual")
    assert_not account.valid?
    assert_includes account.errors.full_messages, "must verify a phone number or connect a Google/Apple account"
  end

  test "oauth_uid must be unique per provider" do
    Account.create!(email: "one@example.com", account_type: "individual", oauth_provider: "google", oauth_uid: "shared-uid")
    dup = Account.new(email: "two@example.com", account_type: "individual", oauth_provider: "google", oauth_uid: "shared-uid")
    assert_not dup.valid?
  end

  test "the same oauth_uid is allowed across different providers" do
    Account.create!(email: "one@example.com", account_type: "individual", oauth_provider: "google", oauth_uid: "shared-uid")
    other = Account.new(email: "two@example.com", account_type: "individual", oauth_provider: "apple", oauth_uid: "shared-uid")
    assert other.valid?
  end
end
