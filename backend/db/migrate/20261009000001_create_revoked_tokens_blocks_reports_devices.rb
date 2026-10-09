class CreateRevokedTokensBlocksReportsDevices < ActiveRecord::Migration[8.1]
  def change
    create_table :revoked_tokens do |t|
      t.string :jti, null: false, index: { unique: true }
      t.datetime :expires_at, null: false, index: true
      t.timestamps
    end

    create_table :blocks do |t|
      t.references :account, null: false, foreign_key: true
      t.references :blocked_profile, null: false, foreign_key: { to_table: :profiles }
      t.timestamps
    end
    add_index :blocks, [ :account_id, :blocked_profile_id ], unique: true

    create_table :reports do |t|
      # Nullable: a report outlives the reporter's account deletion.
      t.references :reporter_account, foreign_key: { to_table: :accounts }
      t.references :reported_profile, null: false, foreign_key: { to_table: :profiles }
      t.string :reason, null: false
      t.text :details
      t.timestamps
    end

    create_table :devices do |t|
      t.references :account, null: false, foreign_key: true
      t.string :token, null: false, index: { unique: true }
      t.string :platform, null: false
      t.timestamps
    end
  end
end
