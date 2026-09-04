class CreateInterests < ActiveRecord::Migration[8.1]
  def change
    create_table :interests do |t|
      t.integer :sender_profile_id, null: false
      t.integer :receiver_profile_id, null: false
      t.string :status, null: false, default: "pending"

      t.timestamps
    end

    add_index :interests, :sender_profile_id
    add_index :interests, :receiver_profile_id
    add_index :interests, [:sender_profile_id, :receiver_profile_id], unique: true

    add_foreign_key :interests, :profiles, column: :sender_profile_id
    add_foreign_key :interests, :profiles, column: :receiver_profile_id
  end
end