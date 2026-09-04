class CreateAccounts < ActiveRecord::Migration[8.1]
  def change
    create_table :accounts do |t|
      t.string :email
      t.string :phone
      t.string :password_digest, null: false
      t.string :account_type, null: false, default: "individual"

      t.timestamps
    end
    add_index :accounts, :email, unique: true
    add_index :accounts, :phone, unique: true
  end
end