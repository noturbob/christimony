class CreateProfilePhotos < ActiveRecord::Migration[8.1]
  def change
    create_table :profile_photos do |t|
      t.references :profile, null: false, foreign_key: true
      t.string :url, null: false
      t.integer :position, null: false, default: 0

      t.timestamps
    end

    add_index :profile_photos, [:profile_id, :position]
  end
end