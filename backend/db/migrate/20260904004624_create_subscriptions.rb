class CreateSubscriptions < ActiveRecord::Migration[8.1]
  def change
    create_table :subscriptions do |t|
      t.references :account, null: false, foreign_key: true
      t.string :plan, null: false, default: "free"
      t.string :status, null: false, default: "active"
      t.datetime :started_at, null: false
      t.datetime :expires_at
      t.string :payment_provider_ref

      t.timestamps
    end

    add_index :subscriptions, [:account_id, :status]
  end
end