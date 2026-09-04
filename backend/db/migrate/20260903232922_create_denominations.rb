class CreateDenominations < ActiveRecord::Migration[8.1]
  def change
    create_table :denominations do |t|
      t.string :name, null: false

      t.timestamps
    end
    add_index :denominations, :name, unique: true
  end
end