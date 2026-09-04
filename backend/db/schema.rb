# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_09_03_235241) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string "account_type", default: "individual", null: false
    t.datetime "created_at", null: false
    t.string "email"
    t.string "password_digest", null: false
    t.string "phone"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_accounts_on_email", unique: true
    t.index ["phone"], name: "index_accounts_on_phone", unique: true
  end

  create_table "denominations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_denominations_on_name", unique: true
  end

  create_table "interests", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "receiver_profile_id", null: false
    t.integer "sender_profile_id", null: false
    t.string "status", default: "pending", null: false
    t.datetime "updated_at", null: false
    t.index ["receiver_profile_id"], name: "index_interests_on_receiver_profile_id"
    t.index ["sender_profile_id", "receiver_profile_id"], name: "index_interests_on_sender_profile_id_and_receiver_profile_id", unique: true
    t.index ["sender_profile_id"], name: "index_interests_on_sender_profile_id"
  end

  create_table "introductions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "parent_match_id", null: false
    t.string "status", default: "pending_both", null: false
    t.datetime "updated_at", null: false
    t.integer "ward_a_id", null: false
    t.integer "ward_b_id", null: false
    t.index ["parent_match_id"], name: "index_introductions_on_parent_match_id"
    t.index ["ward_a_id"], name: "index_introductions_on_ward_a_id"
    t.index ["ward_b_id"], name: "index_introductions_on_ward_b_id"
  end

  create_table "matches", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "match_type", default: "direct", null: false
    t.datetime "matched_at", null: false
    t.integer "profile_a_id", null: false
    t.integer "profile_b_id", null: false
    t.datetime "updated_at", null: false
    t.index ["profile_a_id"], name: "index_matches_on_profile_a_id"
    t.index ["profile_b_id"], name: "index_matches_on_profile_b_id"
  end

  create_table "profile_accesses", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.datetime "activated_at"
    t.datetime "created_at", null: false
    t.datetime "invited_at"
    t.bigint "profile_id", null: false
    t.string "role", default: "owner", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_profile_accesses_on_account_id"
    t.index ["profile_id", "account_id"], name: "index_profile_accesses_on_profile_id_and_account_id", unique: true
    t.index ["profile_id"], name: "index_profile_accesses_on_profile_id"
  end

  create_table "profiles", force: :cascade do |t|
    t.text "bio"
    t.string "city"
    t.datetime "created_at", null: false
    t.bigint "denomination_id"
    t.date "dob"
    t.string "education"
    t.string "gender"
    t.string "name", null: false
    t.string "profession"
    t.string "profile_type", default: "self", null: false
    t.string "status", default: "active", null: false
    t.datetime "updated_at", null: false
    t.index ["city"], name: "index_profiles_on_city"
    t.index ["denomination_id"], name: "index_profiles_on_denomination_id"
  end

  add_foreign_key "interests", "profiles", column: "receiver_profile_id"
  add_foreign_key "interests", "profiles", column: "sender_profile_id"
  add_foreign_key "introductions", "matches", column: "parent_match_id"
  add_foreign_key "introductions", "profiles", column: "ward_a_id"
  add_foreign_key "introductions", "profiles", column: "ward_b_id"
  add_foreign_key "matches", "profiles", column: "profile_a_id"
  add_foreign_key "matches", "profiles", column: "profile_b_id"
  add_foreign_key "profile_accesses", "accounts"
  add_foreign_key "profile_accesses", "profiles"
  add_foreign_key "profiles", "denominations"
end
