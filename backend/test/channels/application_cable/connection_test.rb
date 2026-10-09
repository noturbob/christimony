require "test_helper"

class ApplicationCable::ConnectionTest < ActionCable::Connection::TestCase
  test "connects with a valid token" do
    account = create_account
    connect params: { token: JsonWebToken.encode(account_id: account.id) }
    assert_equal account, connection.current_account
  end

  test "rejects a missing or invalid token" do
    assert_reject_connection { connect }
    assert_reject_connection { connect params: { token: "garbage" } }
  end

  test "rejects a revoked token" do
    token = JsonWebToken.encode(account_id: create_account.id)
    RevokedToken.revoke!(JsonWebToken.decode(token))
    assert_reject_connection { connect params: { token: token } }
  end
end
