class CreateProfilePasses < ActiveRecord::Migration[8.1]
  def change
    create_table :profile_passes do |t|
      t.references :profile, null: false, foreign_key: true
      t.references :passed_profile, null: false, foreign_key: { to_table: :profiles }
      t.timestamps
    end
    add_index :profile_passes, [ :profile_id, :passed_profile_id ], unique: true
  end
end
