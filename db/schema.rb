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

ActiveRecord::Schema.define(version: 20150119010006) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "caps", force: :cascade do |t|
    t.float    "fpl_income"
    t.float    "premium_cap"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cms_data", force: :cascade do |t|
    t.string "key"
    t.text   "value"
  end

  create_table "cost_maps", force: :cascade do |t|
    t.string   "consumer_type"
    t.integer  "child_number"
    t.integer  "age_threshold"
    t.string   "service"
    t.string   "charge_type"
    t.integer  "plan_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "val"
  end

  create_table "cpt_code_maps", force: :cascade do |t|
    t.string   "cpt_code"
    t.string   "procedure_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fpls", force: :cascade do |t|
    t.integer  "household_size"
    t.integer  "fpl_amt"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "medicaids", force: :cascade do |t|
    t.string   "state"
    t.float    "fpl_floor"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "address"
    t.string   "city"
    t.string   "zip"
    t.string   "phone"
    t.string   "url"
    t.string   "agency"
  end

  create_table "navbar_entries", force: :cascade do |t|
    t.string   "title"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "oauth_access_grants", force: :cascade do |t|
    t.integer  "resource_owner_id", null: false
    t.integer  "application_id",    null: false
    t.string   "token",             null: false
    t.integer  "expires_in",        null: false
    t.text     "redirect_uri",      null: false
    t.datetime "created_at",        null: false
    t.datetime "revoked_at"
    t.string   "scopes"
  end

  add_index "oauth_access_grants", ["token"], name: "index_oauth_access_grants_on_token", unique: true, using: :btree

  create_table "oauth_access_tokens", force: :cascade do |t|
    t.integer  "resource_owner_id"
    t.integer  "application_id"
    t.string   "token",             null: false
    t.string   "refresh_token"
    t.integer  "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at",        null: false
    t.string   "scopes"
  end

  add_index "oauth_access_tokens", ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true, using: :btree
  add_index "oauth_access_tokens", ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id", using: :btree
  add_index "oauth_access_tokens", ["token"], name: "index_oauth_access_tokens_on_token", unique: true, using: :btree

  create_table "oauth_applications", force: :cascade do |t|
    t.string   "name",         null: false
    t.string   "uid",          null: false
    t.string   "secret",       null: false
    t.text     "redirect_uri", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "oauth_applications", ["uid"], name: "index_oauth_applications_on_uid", unique: true, using: :btree

  create_table "plan_url_maps", force: :cascade do |t|
    t.string "state"
    t.string "rating_area"
    t.text   "url"
    t.string "plan_name"
    t.string "issuer_name"
  end

  create_table "plans", force: :cascade do |t|
    t.text     "payload"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "plan_identifier"
    t.text     "map_keys"
    t.string   "state"
    t.string   "county"
    t.text     "map_keys_string"
    t.text     "payload_string"
    t.integer  "profile_id"
    t.string   "rating_area"
    t.string   "metal_level"
    t.text     "network_url_attr"
  end

  create_table "profiles", force: :cascade do |t|
    t.integer  "user_id"
    t.text     "demographic_data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "pd_data"
    t.text     "drug_data"
  end

  create_table "rating_areas", force: :cascade do |t|
    t.string   "zip_code"
    t.string   "county"
    t.string   "state"
    t.string   "rating_area"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "saved_plans", force: :cascade do |t|
    t.integer "plan_id"
    t.integer "profile_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "specialty_drugs", force: :cascade do |t|
    t.string   "name"
    t.string   "brand_equiv"
    t.string   "drug_class"
    t.datetime "created_at"
    t.datetime "updated_at"
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
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin"
    t.integer  "age"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "zip_infos", force: :cascade do |t|
    t.string   "zip"
    t.string   "zip_type"
    t.string   "primary_city"
    t.text     "acceptable_cities"
    t.text     "unacceptable_cities"
    t.string   "state"
    t.string   "county"
    t.string   "timezone"
    t.string   "area_codes"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
