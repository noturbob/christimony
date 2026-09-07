class MakeProfilePhotoUrlOptional < ActiveRecord::Migration[8.1]
  def change
    change_column_null :profile_photos, :url, true
  end
end