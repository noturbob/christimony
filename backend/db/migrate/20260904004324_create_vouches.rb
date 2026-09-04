class CreateVouches < ActiveRecord::Migration[8.1]
  def change
    create_table :vouches do |t|
      t.references :profile, null: false, foreign_key: true
      t.string :voucher_name, null: false
      t.string :voucher_role, null: false
      t.string :status, null: false, default: "pending"

      t.timestamps
    end
  end
end