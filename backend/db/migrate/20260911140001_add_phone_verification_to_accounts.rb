class AddPhoneVerificationToAccounts < ActiveRecord::Migration[8.1]
  def change
    add_column :accounts, :phone_verified_at, :datetime
    change_column_null :accounts, :password_digest, true
  end
end
