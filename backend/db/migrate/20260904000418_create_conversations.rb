class CreateConversations < ActiveRecord::Migration[8.1]
  def change
    create_table :conversations do |t|
      t.references :match, null: false, foreign_key: true, index: { unique: true }

      t.timestamps
    end
  end
end