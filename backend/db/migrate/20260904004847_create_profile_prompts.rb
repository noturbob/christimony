class CreateProfilePrompts < ActiveRecord::Migration[8.1]
  def change
    create_table :profile_prompts do |t|
      t.references :profile, null: false, foreign_key: true
      t.string :question, null: false
      t.text :answer, null: false

      t.timestamps
    end
  end
end