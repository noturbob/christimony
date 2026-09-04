class CreateIntroductions < ActiveRecord::Migration[8.1]
  def change
    create_table :introductions do |t|
      t.references :parent_match, null: false, foreign_key: { to_table: :matches }
      t.integer :ward_a_id, null: false
      t.integer :ward_b_id, null: false
      t.string :status, null: false, default: "pending_both"

      t.timestamps
    end

    add_index :introductions, :ward_a_id
    add_index :introductions, :ward_b_id

    add_foreign_key :introductions, :profiles, column: :ward_a_id
    add_foreign_key :introductions, :profiles, column: :ward_b_id
  end
end