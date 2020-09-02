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

ActiveRecord::Schema.define(version: 2020_06_04_024321) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "first_name", default: "", null: false
    t.string "last_name", default: "", null: false
    t.boolean "is_god", default: false, null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "app_id"
    t.index ["app_id"], name: "index_admins_on_app_id"
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "apps", force: :cascade do |t|
    t.string "app_name", default: "", null: false
    t.string "owner_country", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "contents", force: :cascade do |t|
    t.string "title", default: "", null: false
    t.text "body", default: "", null: false
    t.string "content_type", default: "", null: false
    t.bigint "app_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "source_link"
    t.index ["app_id"], name: "index_contents_on_app_id"
  end

  create_table "groups", force: :cascade do |t|
    t.string "description"
    t.string "kind"
    t.string "details"
    t.bigint "manager_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_groups_on_deleted_at"
    t.index ["manager_id"], name: "index_groups_on_manager_id"
  end

  create_table "households", force: :cascade do |t|
    t.string "description"
    t.date "birthdate"
    t.string "country"
    t.string "gender"
    t.string "race"
    t.string "kinship"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.string "picture"
    t.index ["deleted_at"], name: "index_households_on_deleted_at"
    t.index ["user_id"], name: "index_households_on_user_id"
  end

  create_table "jwt_blacklist", force: :cascade do |t|
    t.string "jti", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["jti"], name: "index_jwt_blacklist_on_jti"
  end

  create_table "managers", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.bigint "app_id"
    t.index ["app_id"], name: "index_managers_on_app_id"
    t.index ["email"], name: "index_managers_on_email", unique: true
    t.index ["reset_password_token"], name: "index_managers_on_reset_password_token", unique: true
  end

  create_table "public_hospitals", force: :cascade do |t|
    t.string "description"
    t.float "latitude"
    t.float "longitude"
    t.string "kind"
    t.string "phone"
    t.text "details"
    t.bigint "app_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["app_id"], name: "index_public_hospitals_on_app_id"
  end

  create_table "rumors", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.integer "confirmed_cases"
    t.integer "confirmed_deaths"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "school_units", force: :cascade do |t|
    t.string "code"
    t.string "description"
    t.string "address"
    t.string "cep"
    t.string "phone"
    t.string "fax"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "surveys", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "household_id"
    t.float "latitude"
    t.float "longitude"
    t.date "bad_since"
    t.text "symptom"
    t.string "street"
    t.string "city"
    t.string "state"
    t.string "country"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.string "traveled_to"
    t.string "contact_with_symptom"
    t.boolean "went_to_hospital"
    t.index ["deleted_at"], name: "index_surveys_on_deleted_at"
    t.index ["household_id"], name: "index_surveys_on_household_id"
    t.index ["user_id"], name: "index_surveys_on_user_id"
  end

  create_table "symptoms", force: :cascade do |t|
    t.string "description"
    t.string "code"
    t.integer "priority"
    t.text "details"
    t.bigint "app_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["app_id"], name: "index_symptoms_on_app_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "user_name"
    t.datetime "birthdate"
    t.string "country"
    t.string "gender"
    t.string "race"
    t.boolean "is_professional", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "app_id"
    t.datetime "deleted_at"
    t.string "picture"
    t.string "identification_code"
    t.string "state"
    t.string "city"
    t.bigint "group_id"
    t.boolean "risk_group"
    t.string "aux_code"
    t.bigint "school_unit_id"
    t.index ["app_id"], name: "index_users_on_app_id"
    t.index ["deleted_at"], name: "index_users_on_deleted_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["group_id"], name: "index_users_on_group_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["school_unit_id"], name: "index_users_on_school_unit_id"
  end

  add_foreign_key "admins", "apps"
  add_foreign_key "contents", "apps"
  add_foreign_key "groups", "managers"
  add_foreign_key "households", "users"
  add_foreign_key "managers", "apps"
  add_foreign_key "public_hospitals", "apps"
  add_foreign_key "surveys", "households"
  add_foreign_key "surveys", "users"
  add_foreign_key "symptoms", "apps"
  add_foreign_key "users", "apps"
  add_foreign_key "users", "groups"
  add_foreign_key "users", "school_units"
end
