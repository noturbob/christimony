class AddOauthToAccounts < ActiveRecord::Migration[8.1]
  def change
    add_column :accounts, :oauth_provider, :string
    add_column :accounts, :oauth_uid, :string
    add_index :accounts, [:oauth_provider, :oauth_uid], unique: true
  end
end
