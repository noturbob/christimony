class CreateMessages < ActiveRecord::Migration[8.1]
  def change
    create_table :messages do |t|
      t.references :conversation, null: false, foreign_key: true
      t.integer :sender_account_id, null: false
      t.text :body, null: false
      t.datetime :sent_at, null: false
      t.datetime :read_at

      t.timestamps
    end

    add_index :messages, :sender_account_id
    add_foreign_key :messages, :accounts, column: :sender_account_id
  end
end