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
end