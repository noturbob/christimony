class CreateOtpCodes < ActiveRecord::Migration[8.1]
  def change
    create_table :otp_codes do |t|
      t.string :phone, null: false
      t.string :code_digest, null: false
      t.string :purpose, null: false, default: "login"
      t.datetime :expires_at, null: false
      t.integer :attempts, null: false, default: 0
      t.datetime :consumed_at
      t.datetime :last_sent_at

      t.timestamps
    end

    add_index :otp_codes, [ :phone, :purpose, :consumed_at ]
  end
end
