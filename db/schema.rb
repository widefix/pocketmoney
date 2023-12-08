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

ActiveRecord::Schema.define(version: 2023_12_08_144106) do

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
    t.string "parental_key"
    t.index ["parental_key"], name: "index_account_shares_on_parental_key"
  end

  create_table "accounts", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "parent_id"
    t.string "email", default: "", null: false
    t.boolean "notification", default: false
    t.datetime "archived_at"
    t.boolean "notify_parents", default: true
    t.string "accumulative_balance_timeframe", default: "day"
    t.index ["parent_id"], name: "index_accounts_on_parent_id"
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index %w[record_type record_id name blob_id], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index %w[blob_id variation_digest], name: "index_active_storage_variant_records_uniqueness", unique: true
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
    t.datetime "goal_achieved_notified_at"
    t.datetime "goal_almost_achieved_notified_at"
    t.datetime "accomplished_at"
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
    t.string "parental_key"
    t.integer "sign_in_count"
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.index ["account_id"], name: "index_users_on_account_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["parental_key"], name: "index_users_on_parental_key"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "account_automatic_topup_configs", "accounts", column: "from_account_id"
  add_foreign_key "account_automatic_topup_configs", "accounts", column: "to_account_id"
  add_foreign_key "account_shares", "accounts", on_delete: :cascade
  add_foreign_key "account_shares", "users", on_delete: :cascade
  add_foreign_key "accounts", "accounts", column: "parent_id"
  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "feedbacks", "users"
  add_foreign_key "objectives", "accounts"
  add_foreign_key "transactions", "accounts", column: "from_account_id"
  add_foreign_key "transactions", "accounts", column: "to_account_id"
  add_foreign_key "transactions", "users", column: "originator_id"
  add_foreign_key "users", "accounts"
end
