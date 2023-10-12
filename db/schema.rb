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

ActiveRecord::Schema.define(version: 2023_10_01_201052) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "account_automatic_topup_configs", force: :cascade do |t|
    t.decimal "amount", precision: 10, scale: 2, null: false
    t.bigint "from_account_id", null: false
    t.bigint "to_account_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["from_account_id"], name: "index_account_automatic_topup_configs_on_from_account_id"
    t.index ["to_account_id"], name: "index_account_automatic_topup_configs_on_to_account_id"
  end

  create_table "account_shares", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "email"
    t.string "name"
    t.string "token"
    t.bigint "account_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "accepted_at"
  end

  create_table "accounts", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "parent_id"
    t.string "email", default: "", null: false
    t.boolean "notification", default: false
    t.datetime "archived_at"
    t.index ["parent_id"], name: "index_accounts_on_parent_id"
  end

  create_table "feedbacks", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_feedbacks_on_user_id"
  end

  create_table "objectives", force: :cascade do |t|
    t.string "name", null: false
    t.decimal "amount", precision: 10, scale: 2, null: false
    t.bigint "account_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_objectives_on_account_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.decimal "amount", precision: 10, scale: 2, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "to_account_id"
    t.bigint "from_account_id"
    t.string "description"
    t.bigint "originator_id"
    t.string "access_token"
    t.index ["from_account_id"], name: "index_transactions_on_from_account_id"
    t.index ["originator_id"], name: "index_transactions_on_originator_id"
    t.index ["to_account_id"], name: "index_transactions_on_to_account_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "account_id"
    t.string "name"
    t.string "uid"
    t.string "avatar_url"
    t.string "provider"
    t.index ["account_id"], name: "index_users_on_account_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "account_automatic_topup_configs", "accounts", column: "from_account_id"
  add_foreign_key "account_automatic_topup_configs", "accounts", column: "to_account_id"
  add_foreign_key "account_shares", "accounts", on_delete: :cascade
  add_foreign_key "account_shares", "users", on_delete: :cascade
  add_foreign_key "accounts", "accounts", column: "parent_id"
  add_foreign_key "feedbacks", "users"
  add_foreign_key "objectives", "accounts"
  add_foreign_key "transactions", "accounts", column: "from_account_id"
  add_foreign_key "transactions", "accounts", column: "to_account_id"
  add_foreign_key "transactions", "users", column: "originator_id"
  add_foreign_key "users", "accounts"
end
