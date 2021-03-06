# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170527123918) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "accounts", force: :cascade do |t|
    t.string   "name"
    t.hstore   "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "industry"
  end

  create_table "activities", force: :cascade do |t|
    t.string   "name"
    t.integer  "user_id"
    t.integer  "transaction_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "account_id"
  end

  create_table "balance_sheets", force: :cascade do |t|
    t.string   "name"
    t.integer  "category",                                 default: 0,     null: false
    t.decimal  "current_balance", precision: 10, scale: 2, default: 0.0
    t.datetime "created_at",                                               null: false
    t.datetime "updated_at",                                               null: false
    t.integer  "account_id"
    t.boolean  "header",                                   default: false
    t.string   "account_number"
    t.decimal  "opening_balance", precision: 10, scale: 2, default: 0.0
    t.decimal  "temp_balance",    precision: 10, scale: 2, default: 0.0
  end

  create_table "balances", force: :cascade do |t|
    t.integer  "transaction_item_id"
    t.integer  "balance_sheet_id"
    t.decimal  "balance",             precision: 16, scale: 2, default: 0.0
    t.datetime "created_at",                                                 null: false
    t.datetime "updated_at",                                                 null: false
  end

  create_table "items", force: :cascade do |t|
    t.string   "name"
    t.integer  "account_id"
    t.datetime "created_at",                                                          null: false
    t.datetime "updated_at",                                                          null: false
    t.text     "description"
    t.decimal  "cost",                  precision: 16, scale: 2, default: 0.0
    t.decimal  "income",                precision: 16, scale: 2, default: 0.0
    t.integer  "quantity",                                       default: 0
    t.decimal  "purchase_price",        precision: 10, scale: 2, default: 0.0
    t.decimal  "selling_price",         precision: 10, scale: 2, default: 0.0
    t.string   "unit",                                           default: "none",     null: false
    t.string   "item_number",                                    default: "10000000", null: false
    t.integer  "category",                                       default: 0,          null: false
    t.integer  "allocated_to_selling"
    t.integer  "allocated_to_purchase"
  end

  create_table "persons", force: :cascade do |t|
    t.integer  "person_type",                                   default: 0,   null: false
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.string   "phone"
    t.string   "mobile"
    t.hstore   "address"
    t.integer  "account_id"
    t.datetime "created_at",                                                  null: false
    t.datetime "updated_at",                                                  null: false
    t.decimal  "balance",              precision: 16, scale: 2, default: 0.0
    t.text     "notes"
    t.integer  "credit_terms",                                  default: 0,   null: false
    t.decimal  "credit_limit",         precision: 16, scale: 2, default: 0.0, null: false
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
  end

  create_table "transaction_items", force: :cascade do |t|
    t.decimal  "amount",         precision: 16, scale: 2, default: 0.0
    t.integer  "transaction_id"
    t.datetime "created_at",                                            null: false
    t.datetime "updated_at",                                            null: false
    t.integer  "item_id"
    t.integer  "quantity",                                default: 0
    t.decimal  "rate",           precision: 8,  scale: 2, default: 0.0
  end

  create_table "transactions", force: :cascade do |t|
    t.string   "transaction_type"
    t.string   "transaction_number"
    t.datetime "transaction_date"
    t.datetime "due_date"
    t.text     "notes"
    t.string   "status"
    t.decimal  "payment",            precision: 16, scale: 2, default: 0.0
    t.decimal  "balance",            precision: 16, scale: 2, default: 0.0
    t.decimal  "total",              precision: 16, scale: 2, default: 0.0
    t.integer  "account_id"
    t.integer  "person_id"
    t.integer  "parent_id"
    t.datetime "created_at",                                                  null: false
    t.datetime "updated_at",                                                  null: false
    t.integer  "payment_method",                              default: 0,     null: false
    t.boolean  "cancelled",                                   default: false, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "username"
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "role",                   default: 0,  null: false
    t.integer  "account_id"
    t.integer  "failed_attempts",        default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
  end

  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

end
