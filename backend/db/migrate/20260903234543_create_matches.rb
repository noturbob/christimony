class CreateMatches < ActiveRecord::Migration[8.1]
  def change
    create_table :matches do |t|
      t.integer :profile_a_id, null: false
      t.integer :profile_b_id, null: false
      t.string :match_type, null: false, default: "direct"
      t.datetime :matched_at, null: false

      t.timestamps
    end

    add_index :matches, :profile_a_id
    add_index :matches, :profile_b_id

    add_foreign_key :matches, :profiles, column: :profile_a_id
    add_foreign_key :matches, :profiles, column: :profile_b_id
  end
end