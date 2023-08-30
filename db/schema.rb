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

ActiveRecord::Schema.define(version: 2023_08_30_001808) do

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
    t.string "aux_code"
    t.string "created_by"
    t.string "updated_by"
    t.string "deleted_by"
    t.boolean "first_access", default: true
    t.index ["app_id"], name: "index_admins_on_app_id"
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "apps", force: :cascade do |t|
    t.string "app_name", default: "", null: false
    t.string "owner_country", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "twitter"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "app_id"
    t.index ["app_id"], name: "index_categories_on_app_id"
  end

  create_table "city_managers", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "app_id"
    t.string "name"
    t.string "city"
    t.string "aux_code"
    t.datetime "deleted_at"
    t.string "created_by"
    t.string "updated_by"
    t.string "deleted_by"
    t.boolean "first_access", default: true
    t.index ["app_id"], name: "index_city_managers_on_app_id"
    t.index ["deleted_at"], name: "index_city_managers_on_deleted_at"
    t.index ["email"], name: "index_city_managers_on_email", unique: true
    t.index ["reset_password_token"], name: "index_city_managers_on_reset_password_token", unique: true
  end

  create_table "contents", force: :cascade do |t|
    t.string "title", default: "", null: false
    t.text "body", default: "", null: false
    t.string "content_type", default: "", null: false
    t.bigint "app_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "source_link"
    t.string "icon"
    t.string "created_by"
    t.string "updated_by"
    t.string "deleted_by"
    t.bigint "group_manager_id"
    t.index ["app_id"], name: "index_contents_on_app_id"
    t.index ["group_manager_id"], name: "index_contents_on_group_manager_id"
  end

  create_table "crono_jobs", force: :cascade do |t|
    t.string "job_id", null: false
    t.text "log"
    t.datetime "last_performed_at"
    t.boolean "healthy"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_id"], name: "index_crono_jobs_on_job_id", unique: true
  end

  create_table "doses", force: :cascade do |t|
    t.datetime "date", null: false
    t.integer "dose", null: false
    t.bigint "vaccine_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_doses_on_user_id"
    t.index ["vaccine_id"], name: "index_doses_on_vaccine_id"
  end

  create_table "flexible_answers", force: :cascade do |t|
    t.bigint "flexible_form_version_id"
    t.jsonb "data"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "external_system_integration_id"
    t.index ["flexible_form_version_id"], name: "index_flexible_answers_on_flexible_form_version_id"
    t.index ["user_id"], name: "index_flexible_answers_on_user_id"
  end

  create_table "flexible_form_versions", force: :cascade do |t|
    t.integer "version"
    t.text "notes"
    t.bigint "flexible_form_id"
    t.jsonb "data"
    t.datetime "version_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["flexible_form_id"], name: "index_flexible_form_versions_on_flexible_form_id"
  end

  create_table "flexible_forms", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "form_type"
    t.bigint "group_manager_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_manager_id"], name: "index_flexible_forms_on_group_manager_id"
  end

  create_table "form_answers", force: :cascade do |t|
    t.bigint "form_id"
    t.bigint "form_question_id"
    t.bigint "form_option_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["form_id"], name: "index_form_answers_on_form_id"
    t.index ["form_option_id"], name: "index_form_answers_on_form_option_id"
    t.index ["form_question_id"], name: "index_form_answers_on_form_question_id"
    t.index ["user_id"], name: "index_form_answers_on_user_id"
  end

  create_table "form_options", force: :cascade do |t|
    t.boolean "value"
    t.string "text"
    t.integer "order"
    t.bigint "form_question_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["form_question_id"], name: "index_form_options_on_form_question_id"
  end

  create_table "form_questions", force: :cascade do |t|
    t.string "kind"
    t.string "text"
    t.integer "order"
    t.bigint "form_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["form_id"], name: "index_form_questions_on_form_id"
  end

  create_table "forms", force: :cascade do |t|
    t.bigint "group_manager_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_manager_id"], name: "index_forms_on_group_manager_id"
  end

  create_table "group_manager_teams", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name"
    t.bigint "group_manager_id"
    t.bigint "app_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.string "aux_code"
    t.string "created_by"
    t.string "updated_by"
    t.string "deleted_by"
    t.boolean "first_access", default: true
    t.index ["app_id"], name: "index_group_manager_teams_on_app_id"
    t.index ["deleted_at"], name: "index_group_manager_teams_on_deleted_at"
    t.index ["email"], name: "index_group_manager_teams_on_email", unique: true
    t.index ["group_manager_id"], name: "index_group_manager_teams_on_group_manager_id"
    t.index ["reset_password_token"], name: "index_group_manager_teams_on_reset_password_token", unique: true
  end

  create_table "group_managers", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.bigint "app_id"
    t.string "group_name"
    t.string "twitter"
    t.string "require_id"
    t.integer "id_code_length"
    t.string "vigilance_email"
    t.string "aux_code"
    t.text "vigilance_syndromes", default: ""
    t.text "username_godata", default: ""
    t.text "password_godata", default: ""
    t.text "userid_godata"
    t.string "created_by"
    t.string "updated_by"
    t.string "deleted_by"
    t.boolean "first_access", default: true
    t.text "url_godata", default: ""
    t.index ["app_id"], name: "index_group_managers_on_app_id"
    t.index ["email"], name: "index_group_managers_on_email", unique: true
    t.index ["reset_password_token"], name: "index_group_managers_on_reset_password_token", unique: true
  end

  create_table "groups", force: :cascade do |t|
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.bigint "parent_id"
    t.string "children_label"
    t.string "code"
    t.string "address"
    t.string "cep"
    t.string "phone"
    t.string "email"
    t.integer "group_manager_id"
    t.text "location_name_godata"
    t.text "location_id_godata"
    t.string "created_by"
    t.string "updated_by"
    t.string "deleted_by"
    t.index ["deleted_at"], name: "index_groups_on_deleted_at"
    t.index ["parent_id"], name: "index_groups_on_parent_id"
  end

  create_table "households", force: :cascade do |t|
    t.string "description"
    t.datetime "birthdate"
    t.string "country"
    t.string "gender"
    t.string "race"
    t.string "kinship"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.string "picture"
    t.string "identification_code"
    t.boolean "risk_group"
    t.integer "group_id"
    t.integer "streak", default: 0
    t.bigint "category_id"
    t.index ["category_id"], name: "index_households_on_category_id"
    t.index ["deleted_at"], name: "index_households_on_deleted_at"
    t.index ["user_id"], name: "index_households_on_user_id"
  end

  create_table "jwt_blacklist", force: :cascade do |t|
    t.string "jti", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["jti"], name: "index_jwt_blacklist_on_jti"
  end

  create_table "manager_group_permissions", force: :cascade do |t|
    t.bigint "group_manager_id"
    t.bigint "group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_manager_group_permissions_on_group_id"
    t.index ["group_manager_id"], name: "index_manager_group_permissions_on_group_manager_id"
  end

  create_table "managers", force: :cascade do |t|
    t.string "name"
    t.string "password"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.bigint "app_id"
    t.string "aux_code"
    t.string "created_by"
    t.string "updated_by"
    t.string "deleted_by"
    t.boolean "first_access", default: true
    t.index ["app_id"], name: "index_managers_on_app_id"
    t.index ["email"], name: "index_managers_on_email", unique: true
    t.index ["reset_password_token"], name: "index_managers_on_reset_password_token", unique: true
  end

  create_table "messages", force: :cascade do |t|
    t.string "title"
    t.text "warning_message"
    t.text "go_to_hospital_message"
    t.bigint "syndrome_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "symptom_id"
    t.integer "day", default: -1
    t.string "feedback_message"
    t.index ["symptom_id"], name: "index_messages_on_symptom_id"
    t.index ["syndrome_id"], name: "index_messages_on_syndrome_id"
  end

  create_table "permissions", force: :cascade do |t|
    t.text "models_create"
    t.text "models_read"
    t.text "models_update"
    t.text "models_destroy"
    t.text "models_manage"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "manager_id"
    t.bigint "group_manager_id"
    t.bigint "admin_id"
    t.bigint "group_manager_team_id"
    t.index ["admin_id"], name: "index_permissions_on_admin_id"
    t.index ["group_manager_id"], name: "index_permissions_on_group_manager_id"
    t.index ["group_manager_team_id"], name: "index_permissions_on_group_manager_team_id"
    t.index ["manager_id"], name: "index_permissions_on_manager_id"
  end

  create_table "pre_registers", force: :cascade do |t|
    t.string "cnpj"
    t.string "phone"
    t.string "organization_kind"
    t.string "state"
    t.string "company_name"
    t.bigint "app_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email"
    t.index ["app_id"], name: "index_pre_registers_on_app_id"
    t.index ["email"], name: "index_pre_registers_on_email", unique: true
  end

  create_table "rumors", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "latitude"
    t.float "longitude"
    t.bigint "user_id"
    t.bigint "app_id"
    t.integer "confirmed_deaths"
    t.integer "confirmed_cases"
    t.index ["app_id"], name: "index_rumors_on_app_id"
    t.index ["user_id"], name: "index_rumors_on_user_id"
  end

  create_table "surveys", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "household_id"
    t.float "latitude"
    t.float "longitude"
    t.datetime "bad_since"
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
    t.bigint "syndrome_id"
    t.string "postal_code"
    t.boolean "reviewed"
    t.index ["deleted_at"], name: "index_surveys_on_deleted_at"
    t.index ["household_id"], name: "index_surveys_on_household_id"
    t.index ["syndrome_id"], name: "index_surveys_on_syndrome_id"
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
    t.bigint "syndrome_id"
    t.bigint "message_id"
    t.string "created_by"
    t.string "updated_by"
    t.string "deleted_by"
    t.index ["app_id"], name: "index_symptoms_on_app_id"
    t.index ["message_id"], name: "index_symptoms_on_message_id"
    t.index ["syndrome_id"], name: "index_symptoms_on_syndrome_id"
  end

  create_table "syndrome_symptom_percentages", force: :cascade do |t|
    t.float "percentage"
    t.bigint "symptom_id"
    t.bigint "syndrome_id"
    t.index ["symptom_id"], name: "index_syndrome_symptom_percentages_on_symptom_id"
    t.index ["syndrome_id"], name: "index_syndrome_symptom_percentages_on_syndrome_id"
  end

  create_table "syndromes", force: :cascade do |t|
    t.string "description"
    t.string "details"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "message_id"
    t.bigint "app_id", default: 1
    t.integer "days_period"
    t.string "created_by"
    t.string "updated_by"
    t.string "deleted_by"
    t.float "threshold_score", default: 0.0, null: false
    t.index ["message_id"], name: "index_syndromes_on_message_id"
  end

  create_table "twitter_apis", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "twitterdata"
    t.string "handle"
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
    t.integer "policy_version", default: 2, null: false
    t.integer "streak", default: 0
    t.string "phone"
    t.boolean "is_vigilance", default: false
    t.string "created_by"
    t.string "updated_by"
    t.string "deleted_by"
    t.datetime "first_dose_date"
    t.datetime "second_dose_date"
    t.bigint "vaccine_id"
    t.bigint "category_id"
    t.index ["app_id"], name: "index_users_on_app_id"
    t.index ["category_id"], name: "index_users_on_category_id"
    t.index ["deleted_at"], name: "index_users_on_deleted_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["group_id"], name: "index_users_on_group_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["vaccine_id"], name: "index_users_on_vaccine_id"
  end

  create_table "vaccines", force: :cascade do |t|
    t.string "name"
    t.string "laboratory"
    t.integer "doses"
    t.integer "max_dose_interval"
    t.integer "min_dose_interval"
    t.string "country_origin"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "app_id"
    t.string "disease"
    t.index ["app_id"], name: "index_vaccines_on_app_id"
  end

  add_foreign_key "admins", "apps"
  add_foreign_key "categories", "apps"
  add_foreign_key "city_managers", "apps"
  add_foreign_key "contents", "apps"
  add_foreign_key "contents", "group_managers"
  add_foreign_key "doses", "users"
  add_foreign_key "doses", "vaccines"
  add_foreign_key "flexible_answers", "flexible_form_versions"
  add_foreign_key "flexible_answers", "users"
  add_foreign_key "flexible_form_versions", "flexible_forms"
  add_foreign_key "flexible_forms", "group_managers"
  add_foreign_key "form_answers", "form_options"
  add_foreign_key "form_answers", "form_questions"
  add_foreign_key "form_answers", "forms"
  add_foreign_key "form_answers", "users"
  add_foreign_key "form_options", "form_questions"
  add_foreign_key "form_questions", "forms"
  add_foreign_key "forms", "group_managers"
  add_foreign_key "group_managers", "apps"
  add_foreign_key "households", "categories"
  add_foreign_key "households", "users"
  add_foreign_key "manager_group_permissions", "group_managers"
  add_foreign_key "manager_group_permissions", "groups"
  add_foreign_key "managers", "apps"
  add_foreign_key "messages", "symptoms"
  add_foreign_key "messages", "syndromes"
  add_foreign_key "permissions", "admins"
  add_foreign_key "permissions", "group_manager_teams"
  add_foreign_key "permissions", "group_managers"
  add_foreign_key "permissions", "managers"
  add_foreign_key "pre_registers", "apps"
  add_foreign_key "rumors", "apps"
  add_foreign_key "rumors", "users"
  add_foreign_key "surveys", "households"
  add_foreign_key "surveys", "syndromes"
  add_foreign_key "surveys", "users"
  add_foreign_key "symptoms", "apps"
  add_foreign_key "symptoms", "messages"
  add_foreign_key "symptoms", "syndromes"
  add_foreign_key "syndrome_symptom_percentages", "symptoms"
  add_foreign_key "syndrome_symptom_percentages", "syndromes"
  add_foreign_key "syndromes", "messages"
  add_foreign_key "users", "apps"
  add_foreign_key "users", "categories"
  add_foreign_key "users", "groups"
  add_foreign_key "users", "vaccines"
  add_foreign_key "vaccines", "apps"
end
