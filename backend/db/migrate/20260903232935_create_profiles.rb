class CreateProfiles < ActiveRecord::Migration[8.1]
  def change
    create_table :profiles do |t|
      t.references :denomination, null: true, foreign_key: true
      t.string :profile_type, null: false, default: "self"
      t.string :name, null: false
      t.date :dob
      t.string :gender
      t.string :city
      t.string :education
      t.string :profession
      t.text :bio
      t.string :status, null: false, default: "active"

      t.timestamps
    end
    add_index :profiles, :city
  end
end