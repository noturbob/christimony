require "test_helper"

class AccountTest < ActiveSupport::TestCase
  test "valid with email only" do
    account = Account.new(email: "test@example.com", password: "password123", account_type: "individual")
    assert account.valid?
  end

  test "valid with phone only" do
    account = Account.new(phone: "9999999999", password: "password123", account_type: "individual")
    assert account.valid?
  end

  test "invalid without email or phone" do
    account = Account.new(password: "password123", account_type: "individual")
    assert_not account.valid?
    assert_includes account.errors.full_messages, "must provide either an email or a phone number"
  end

  test "invalid without a recognized account_type" do
    account = Account.new(email: "test@example.com", password: "password123", account_type: "robot")
    assert_not account.valid?
  end

  test "password is hashed, not stored in plain text" do
    account = Account.create!(email: "test@example.com", password: "password123", account_type: "individual")
    assert_not_equal "password123", account.password_digest
  end

  test "authenticate returns the account for a correct password" do
    account = Account.create!(email: "test@example.com", password: "password123", account_type: "individual")
    assert_equal account, account.authenticate("password123")
  end

  test "authenticate returns false for an incorrect password" do
    account = Account.create!(email: "test@example.com", password: "password123", account_type: "individual")
    assert_not account.authenticate("wrongpassword")
  end

  test "email must be unique" do
    Account.create!(email: "dup@example.com", password: "password123", account_type: "individual")
    dup = Account.new(email: "dup@example.com", password: "password123", account_type: "individual")
    assert_not dup.valid?
  end

  test "phone is normalized to E.164 on save" do
    account = Account.create!(phone: "9876500010", password: "password123", account_type: "individual")
    assert_equal "+919876500010", account.phone
  end

  test "an account can exist with no password if the phone is verified" do
    account = Account.new(phone: "9876500011", account_type: "individual", phone_verified_at: Time.current)
    assert account.valid?
  end

  test "an account with neither a password nor a verified phone is invalid" do
    account = Account.new(phone: "9876500012", account_type: "individual")
    assert_not account.valid?
    assert_includes account.errors.full_messages, "must set a password or verify a phone number"
  end
end
