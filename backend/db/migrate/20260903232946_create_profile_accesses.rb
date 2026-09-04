class CreateProfileAccesses < ActiveRecord::Migration[8.1]
  def change
    create_table :profile_accesses do |t|
      t.references :profile, null: false, foreign_key: true
      t.references :account, null: false, foreign_key: true
      t.string :role, null: false, default: "owner"
      t.datetime :invited_at
      t.datetime :activated_at

      t.timestamps
    end
    add_index :profile_accesses, [:profile_id, :account_id], unique: true
  end
end