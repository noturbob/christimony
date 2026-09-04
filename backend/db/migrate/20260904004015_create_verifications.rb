class CreateVerifications < ActiveRecord::Migration[8.1]
  def change
    create_table :verifications do |t|
      t.references :account, null: false, foreign_key: true
      t.string :verification_type, null: false
      t.string :status, null: false, default: "pending"
      t.datetime :verified_at

      t.timestamps
    end

    add_index :verifications, [:account_id, :verification_type]
  end
end