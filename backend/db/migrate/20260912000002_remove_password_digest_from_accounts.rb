class RemovePasswordDigestFromAccounts < ActiveRecord::Migration[8.1]
  def change
    remove_column :accounts, :password_digest, :string
  end
end
