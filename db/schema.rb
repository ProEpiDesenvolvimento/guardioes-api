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

ActiveRecord::Schema.define(version: 2020_08_12_152255) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activity", id: :serial, force: :cascade do |t|
    t.string "topic", limit: 32, null: false
    t.datetime "timestamp", null: false
    t.integer "user_id"
    t.string "model", limit: 16
    t.integer "model_id"
    t.integer "database_id"
    t.integer "table_id"
    t.string "custom_id", limit: 48
    t.string "details", null: false
    t.index ["custom_id"], name: "idx_activity_custom_id"
    t.index ["timestamp"], name: "idx_activity_timestamp"
    t.index ["user_id"], name: "idx_activity_user_id"
  end

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

  create_table "card_label", id: :serial, force: :cascade do |t|
    t.integer "card_id", null: false
    t.integer "label_id", null: false
    t.index ["card_id", "label_id"], name: "unique_card_label_card_id_label_id", unique: true
    t.index ["card_id"], name: "idx_card_label_card_id"
    t.index ["label_id"], name: "idx_card_label_label_id"
  end

  create_table "collection", id: :serial, comment: "Collections are an optional way to organize Cards and handle permissions for them.", force: :cascade do |t|
    t.text "name", null: false, comment: "The user-facing name of this Collection."
    t.text "description", comment: "Optional description for this Collection."
    t.string "color", limit: 7, null: false, comment: "Seven-character hex color for this Collection, including the preceding hash sign."
    t.boolean "archived", default: false, null: false, comment: "Whether this Collection has been archived and should be hidden from users."
    t.string "location", limit: 254, default: "/", null: false, comment: "Directory-structure path of ancestor Collections. e.g. \"/1/2/\" means our Parent is Collection 2, and their parent is Collection 1."
    t.integer "personal_owner_id", comment: "If set, this Collection is a personal Collection, for exclusive use of the User with this ID."
    t.string "slug", limit: 254, null: false, comment: "Sluggified version of the Collection name. Used only for display purposes in URL; not unique or indexed."
    t.string "namespace", limit: 254, comment: "The namespace (hierachy) this Collection belongs to. NULL means the Collection is in the default namespace."
    t.index ["location"], name: "idx_collection_location"
    t.index ["personal_owner_id"], name: "idx_collection_personal_owner_id"
    t.index ["personal_owner_id"], name: "unique_collection_personal_owner_id", unique: true
  end

  create_table "collection_revision", id: :serial, comment: "Used to keep track of changes made to collections.", force: :cascade do |t|
    t.text "before", null: false, comment: "Serialized JSON of the collections graph before the changes."
    t.text "after", null: false, comment: "Serialized JSON of the collections graph after the changes."
    t.integer "user_id", null: false, comment: "The ID of the admin who made this set of changes."
    t.datetime "created_at", null: false, comment: "The timestamp of when these changes were made."
    t.text "remark", comment: "Optional remarks explaining why these changes were made."
  end

  create_table "computation_job", id: :serial, comment: "Stores submitted async computation jobs.", force: :cascade do |t|
    t.integer "creator_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type", limit: 254, null: false
    t.string "status", limit: 254, null: false
    t.text "context"
    t.datetime "ended_at"
  end

  create_table "computation_job_result", id: :serial, comment: "Stores results of async computation jobs.", force: :cascade do |t|
    t.integer "job_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "permanence", limit: 254, null: false
    t.text "payload", null: false
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
    t.index ["app_id"], name: "index_contents_on_app_id"
  end

  create_table "core_session", id: :string, limit: 254, force: :cascade do |t|
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.text "anti_csrf_token", comment: "Anti-CSRF token for full-app embed sessions."
  end

  create_table "core_user", id: :serial, force: :cascade do |t|
    t.string "email", limit: 254, null: false
    t.string "first_name", limit: 254, null: false
    t.string "last_name", limit: 254, null: false
    t.string "password", limit: 254, null: false
    t.string "password_salt", limit: 254, default: "default", null: false
    t.datetime "date_joined", null: false
    t.datetime "last_login"
    t.boolean "is_superuser", null: false
    t.boolean "is_active", null: false
    t.string "reset_token", limit: 254
    t.bigint "reset_triggered"
    t.boolean "is_qbnewb", default: true, null: false
    t.boolean "google_auth", default: false, null: false
    t.boolean "ldap_auth", default: false, null: false
    t.text "login_attributes", comment: "JSON serialized map with attributes used for row level permissions"
    t.datetime "updated_at", comment: "When was this User last updated?"
    t.string "sso_source", limit: 254, comment: "String to indicate the SSO backend the user is from"
    t.string "locale", limit: 5, comment: "Preferred ISO locale (language/country) code, e.g \"en\" or \"en-US\", for this User. Overrides site default."
    t.index ["email"], name: "core_user_email_key", unique: true
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
    t.boolean "require_id"
    t.integer "id_code_length"
    t.index ["app_id"], name: "index_group_managers_on_app_id"
    t.index ["email"], name: "index_group_managers_on_email", unique: true
    t.index ["reset_password_token"], name: "index_group_managers_on_reset_password_token", unique: true
  end

  create_table "group_table_access_policy", id: :serial, comment: "Records that a given Card (Question) should automatically replace a given Table as query source for a given a Perms Group.", force: :cascade do |t|
    t.integer "group_id", null: false, comment: "ID of the Permissions Group this policy affects."
    t.integer "table_id", null: false, comment: "ID of the Table that should get automatically replaced as query source for the Permissions Group."
    t.integer "card_id", comment: "ID of the Card (Question) to be used to replace the Table."
    t.text "attribute_remappings", comment: "JSON-encoded map of user attribute identifier to the param name used in the Card."
    t.index ["table_id", "group_id"], name: "idx_gtap_table_id_group_id"
    t.index ["table_id", "group_id"], name: "unique_gtap_table_id_group_id", unique: true
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
    t.index ["deleted_at"], name: "index_groups_on_deleted_at"
    t.index ["parent_id"], name: "index_groups_on_parent_id"
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
    t.bigint "school_unit_id"
    t.string "identification_code"
    t.boolean "risk_group"
    t.integer "group_id"
    t.index ["deleted_at"], name: "index_households_on_deleted_at"
    t.index ["school_unit_id"], name: "index_households_on_school_unit_id"
    t.index ["user_id"], name: "index_households_on_user_id"
  end

  create_table "jwt_blacklist", force: :cascade do |t|
    t.string "jti", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["jti"], name: "index_jwt_blacklist_on_jti"
  end

  create_table "label", id: :serial, force: :cascade do |t|
    t.string "name", limit: 254, null: false
    t.string "slug", limit: 254, null: false
    t.string "icon", limit: 128
    t.index ["slug"], name: "idx_label_slug"
    t.index ["slug"], name: "label_slug_key", unique: true
  end

  create_table "manager_group_permissions", force: :cascade do |t|
    t.bigint "group_manager_id"
    t.bigint "group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_manager_group_permissions_on_group_id"
    t.index ["group_manager_id"], name: "index_manager_group_permissions_on_group_manager_id"
  end

  create_table "messages", force: :cascade do |t|
    t.string "title"
    t.text "warning_message"
    t.text "go_to_hospital_message"
    t.bigint "syndrome_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "symptom_id"
    t.index ["symptom_id"], name: "index_messages_on_symptom_id"
    t.index ["syndrome_id"], name: "index_messages_on_syndrome_id"
  end

  create_table "metabase_database", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", limit: 254, null: false
    t.text "description"
    t.text "details"
    t.string "engine", limit: 254, null: false
    t.boolean "is_sample", default: false, null: false
    t.boolean "is_full_sync", default: true, null: false
    t.text "points_of_interest"
    t.text "caveats"
    t.string "metadata_sync_schedule", limit: 254, default: "0 50 * * * ? *", null: false, comment: "The cron schedule string for when this database should undergo the metadata sync process (and analysis for new fields)."
    t.string "cache_field_values_schedule", limit: 254, default: "0 50 0 * * ? *", null: false, comment: "The cron schedule string for when FieldValues for eligible Fields should be updated."
    t.string "timezone", limit: 254, comment: "Timezone identifier for the database, set by the sync process"
    t.boolean "is_on_demand", default: false, null: false, comment: "Whether we should do On-Demand caching of FieldValues for this DB. This means FieldValues are updated when their Field is used in a Dashboard or Card param."
    t.text "options", comment: "Serialized JSON containing various options like QB behavior."
    t.boolean "auto_run_queries", default: true, null: false, comment: "Whether to automatically run queries when doing simple filtering and summarizing in the Query Builder."
  end

  create_table "metabase_field", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", limit: 254, null: false
    t.string "base_type", limit: 255, null: false
    t.string "special_type", limit: 255
    t.boolean "active", default: true, null: false
    t.text "description"
    t.boolean "preview_display", default: true, null: false
    t.integer "position", default: 0, null: false
    t.integer "table_id", null: false
    t.integer "parent_id"
    t.string "display_name", limit: 254
    t.string "visibility_type", limit: 32, default: "normal", null: false
    t.integer "fk_target_field_id"
    t.datetime "last_analyzed"
    t.text "points_of_interest"
    t.text "caveats"
    t.text "fingerprint", comment: "Serialized JSON containing non-identifying information about this Field, such as min, max, and percent JSON. Used for classification."
    t.integer "fingerprint_version", default: 0, null: false, comment: "The version of the fingerprint for this Field. Used so we can keep track of which Fields need to be analyzed again when new things are added to fingerprints."
    t.text "database_type", null: false, comment: "The actual type of this column in the database. e.g. VARCHAR or TEXT."
    t.text "has_field_values", comment: "Whether we have FieldValues (\"list\"), should ad-hoc search (\"search\"), disable entirely (\"none\"), or infer dynamically (null)\""
    t.text "settings", comment: "Serialized JSON FE-specific settings like formatting, etc. Scope of what is stored here may increase in future."
    t.integer "database_position", default: 0, null: false
    t.integer "custom_position", default: 0, null: false
    t.index ["parent_id"], name: "idx_field_parent_id"
    t.index ["table_id", "name"], name: "idx_uniq_field_table_id_parent_id_name_2col", unique: true, where: "(parent_id IS NULL)"
    t.index ["table_id", "parent_id", "name"], name: "idx_uniq_field_table_id_parent_id_name", unique: true
    t.index ["table_id"], name: "idx_field_table_id"
  end

  create_table "metabase_fieldvalues", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "values"
    t.text "human_readable_values"
    t.integer "field_id", null: false
    t.index ["field_id"], name: "idx_fieldvalues_field_id"
  end

  create_table "metabase_table", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", limit: 254, null: false
    t.text "description"
    t.string "entity_name", limit: 254
    t.string "entity_type", limit: 254
    t.boolean "active", null: false
    t.integer "db_id", null: false
    t.string "display_name", limit: 254
    t.string "visibility_type", limit: 254
    t.string "schema", limit: 254
    t.text "points_of_interest"
    t.text "caveats"
    t.boolean "show_in_getting_started", default: false, null: false
    t.string "field_order", limit: 254, default: "database", null: false
    t.index ["db_id", "name"], name: "idx_uniq_table_db_id_schema_name_2col", unique: true, where: "(schema IS NULL)"
    t.index ["db_id", "schema", "name"], name: "idx_uniq_table_db_id_schema_name", unique: true
    t.index ["db_id", "schema"], name: "idx_metabase_table_db_id_schema"
    t.index ["db_id"], name: "idx_table_db_id"
    t.index ["show_in_getting_started"], name: "idx_metabase_table_show_in_getting_started"
  end

  create_table "metric", id: :serial, force: :cascade do |t|
    t.integer "table_id", null: false
    t.integer "creator_id", null: false
    t.string "name", limit: 254, null: false
    t.text "description"
    t.boolean "archived", default: false, null: false
    t.text "definition", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "points_of_interest"
    t.text "caveats"
    t.text "how_is_this_calculated"
    t.boolean "show_in_getting_started", default: false, null: false
    t.index ["creator_id"], name: "idx_metric_creator_id"
    t.index ["show_in_getting_started"], name: "idx_metric_show_in_getting_started"
    t.index ["table_id"], name: "idx_metric_table_id"
  end

  create_table "metric_important_field", id: :serial, force: :cascade do |t|
    t.integer "metric_id", null: false
    t.integer "field_id", null: false
    t.index ["field_id"], name: "idx_metric_important_field_field_id"
    t.index ["metric_id", "field_id"], name: "unique_metric_important_field_metric_id_field_id", unique: true
    t.index ["metric_id"], name: "idx_metric_important_field_metric_id"
  end

  create_table "native_query_snippet", id: :serial, comment: "Query snippets (raw text) to be substituted in native queries", force: :cascade do |t|
    t.string "name", limit: 254, null: false, comment: "Name of the query snippet"
    t.text "description"
    t.text "content", null: false, comment: "Raw query snippet"
    t.integer "creator_id", null: false
    t.boolean "archived", default: false, null: false
    t.datetime "created_at", default: -> { "now()" }, null: false
    t.datetime "updated_at", default: -> { "now()" }, null: false
    t.integer "collection_id", comment: "ID of the Snippet Folder (Collection) this Snippet is in, if any"
    t.index ["collection_id"], name: "idx_snippet_collection_id"
    t.index ["name"], name: "idx_snippet_name"
    t.index ["name"], name: "native_query_snippet_name_key", unique: true
  end

  create_table "permissions", id: :serial, force: :cascade do |t|
    t.string "object", limit: 254, null: false
    t.integer "group_id", null: false
    t.index ["group_id", "object"], name: "idx_permissions_group_id_object"
    t.index ["group_id", "object"], name: "permissions_group_id_object_key", unique: true
    t.index ["group_id"], name: "idx_permissions_group_id"
    t.index ["object"], name: "idx_permissions_object"
  end

  create_table "permissions_group", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.index ["name"], name: "idx_permissions_group_name"
    t.index ["name"], name: "unique_permissions_group_name", unique: true
  end

  create_table "permissions_group_membership", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "group_id", null: false
    t.index ["group_id", "user_id"], name: "idx_permissions_group_membership_group_id_user_id"
    t.index ["group_id"], name: "idx_permissions_group_membership_group_id"
    t.index ["user_id", "group_id"], name: "unique_permissions_group_membership_user_id_group_id", unique: true
    t.index ["user_id"], name: "idx_permissions_group_membership_user_id"
  end

  create_table "permissions_revision", id: :serial, comment: "Used to keep track of changes made to permissions.", force: :cascade do |t|
    t.text "before", null: false, comment: "Serialized JSON of the permissions before the changes."
    t.text "after", null: false, comment: "Serialized JSON of the permissions after the changes."
    t.integer "user_id", null: false, comment: "The ID of the admin who made this set of changes."
    t.datetime "created_at", null: false, comment: "The timestamp of when these changes were made."
    t.text "remark", comment: "Optional remarks explaining why these changes were made."
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

  create_table "pulse", id: :serial, force: :cascade do |t|
    t.integer "creator_id", null: false
    t.string "name", limit: 254
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "skip_if_empty", default: false, null: false, comment: "Skip a scheduled Pulse if none of its questions have any results"
    t.string "alert_condition", limit: 254, comment: "Condition (i.e. \"rows\" or \"goal\") used as a guard for alerts"
    t.boolean "alert_first_only", comment: "True if the alert should be disabled after the first notification"
    t.boolean "alert_above_goal", comment: "For a goal condition, alert when above the goal"
    t.integer "collection_id", comment: "Options ID of Collection this Pulse belongs to."
    t.integer "collection_position", limit: 2, comment: "Optional pinned position for this item in its Collection. NULL means item is not pinned."
    t.boolean "archived", default: false, comment: "Has this pulse been archived?"
    t.index ["collection_id"], name: "idx_pulse_collection_id"
    t.index ["creator_id"], name: "idx_pulse_creator_id"
  end

  create_table "pulse_card", id: :serial, force: :cascade do |t|
    t.integer "pulse_id", null: false
    t.integer "card_id", null: false
    t.integer "position", null: false
    t.boolean "include_csv", default: false, null: false, comment: "True if a CSV of the data should be included for this pulse card"
    t.boolean "include_xls", default: false, null: false, comment: "True if a XLS of the data should be included for this pulse card"
    t.index ["card_id"], name: "idx_pulse_card_card_id"
    t.index ["pulse_id"], name: "idx_pulse_card_pulse_id"
  end

  create_table "pulse_channel", id: :serial, force: :cascade do |t|
    t.integer "pulse_id", null: false
    t.string "channel_type", limit: 32, null: false
    t.text "details", null: false
    t.string "schedule_type", limit: 32, null: false
    t.integer "schedule_hour"
    t.string "schedule_day", limit: 64
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "schedule_frame", limit: 32
    t.boolean "enabled", default: true, null: false
    t.index ["pulse_id"], name: "idx_pulse_channel_pulse_id"
    t.index ["schedule_type"], name: "idx_pulse_channel_schedule_type"
  end

  create_table "pulse_channel_recipient", id: :serial, force: :cascade do |t|
    t.integer "pulse_channel_id", null: false
    t.integer "user_id", null: false
  end

  create_table "qrtz_blob_triggers", primary_key: ["sched_name", "trigger_name", "trigger_group"], comment: "Used for Quartz scheduler.", force: :cascade do |t|
    t.string "sched_name", limit: 120, null: false
    t.string "trigger_name", limit: 200, null: false
    t.string "trigger_group", limit: 200, null: false
    t.binary "blob_data"
  end

  create_table "qrtz_calendars", primary_key: ["sched_name", "calendar_name"], comment: "Used for Quartz scheduler.", force: :cascade do |t|
    t.string "sched_name", limit: 120, null: false
    t.string "calendar_name", limit: 200, null: false
    t.binary "calendar", null: false
  end

  create_table "qrtz_cron_triggers", primary_key: ["sched_name", "trigger_name", "trigger_group"], comment: "Used for Quartz scheduler.", force: :cascade do |t|
    t.string "sched_name", limit: 120, null: false
    t.string "trigger_name", limit: 200, null: false
    t.string "trigger_group", limit: 200, null: false
    t.string "cron_expression", limit: 120, null: false
    t.string "time_zone_id", limit: 80
  end

  create_table "qrtz_fired_triggers", primary_key: ["sched_name", "entry_id"], comment: "Used for Quartz scheduler.", force: :cascade do |t|
    t.string "sched_name", limit: 120, null: false
    t.string "entry_id", limit: 95, null: false
    t.string "trigger_name", limit: 200, null: false
    t.string "trigger_group", limit: 200, null: false
    t.string "instance_name", limit: 200, null: false
    t.bigint "fired_time", null: false
    t.bigint "sched_time"
    t.integer "priority", null: false
    t.string "state", limit: 16, null: false
    t.string "job_name", limit: 200
    t.string "job_group", limit: 200
    t.boolean "is_nonconcurrent"
    t.boolean "requests_recovery"
    t.index ["sched_name", "instance_name", "requests_recovery"], name: "idx_qrtz_ft_inst_job_req_rcvry"
    t.index ["sched_name", "instance_name"], name: "idx_qrtz_ft_trig_inst_name"
    t.index ["sched_name", "job_group"], name: "idx_qrtz_ft_jg"
    t.index ["sched_name", "job_name", "job_group"], name: "idx_qrtz_ft_j_g"
    t.index ["sched_name", "trigger_group"], name: "idx_qrtz_ft_tg"
    t.index ["sched_name", "trigger_name", "trigger_group"], name: "idx_qrtz_ft_t_g"
  end

  create_table "qrtz_job_details", primary_key: ["sched_name", "job_name", "job_group"], comment: "Used for Quartz scheduler.", force: :cascade do |t|
    t.string "sched_name", limit: 120, null: false
    t.string "job_name", limit: 200, null: false
    t.string "job_group", limit: 200, null: false
    t.string "description", limit: 250
    t.string "job_class_name", limit: 250, null: false
    t.boolean "is_durable", null: false
    t.boolean "is_nonconcurrent", null: false
    t.boolean "is_update_data", null: false
    t.boolean "requests_recovery", null: false
    t.binary "job_data"
    t.index ["sched_name", "job_group"], name: "idx_qrtz_j_grp"
    t.index ["sched_name", "requests_recovery"], name: "idx_qrtz_j_req_recovery"
  end

  create_table "qrtz_locks", primary_key: ["sched_name", "lock_name"], comment: "Used for Quartz scheduler.", force: :cascade do |t|
    t.string "sched_name", limit: 120, null: false
    t.string "lock_name", limit: 40, null: false
  end

  create_table "qrtz_paused_trigger_grps", primary_key: ["sched_name", "trigger_group"], comment: "Used for Quartz scheduler.", force: :cascade do |t|
    t.string "sched_name", limit: 120, null: false
    t.string "trigger_group", limit: 200, null: false
  end

  create_table "qrtz_scheduler_state", primary_key: ["sched_name", "instance_name"], comment: "Used for Quartz scheduler.", force: :cascade do |t|
    t.string "sched_name", limit: 120, null: false
    t.string "instance_name", limit: 200, null: false
    t.bigint "last_checkin_time", null: false
    t.bigint "checkin_interval", null: false
  end

  create_table "qrtz_simple_triggers", primary_key: ["sched_name", "trigger_name", "trigger_group"], comment: "Used for Quartz scheduler.", force: :cascade do |t|
    t.string "sched_name", limit: 120, null: false
    t.string "trigger_name", limit: 200, null: false
    t.string "trigger_group", limit: 200, null: false
    t.bigint "repeat_count", null: false
    t.bigint "repeat_interval", null: false
    t.bigint "times_triggered", null: false
  end

  create_table "qrtz_simprop_triggers", primary_key: ["sched_name", "trigger_name", "trigger_group"], comment: "Used for Quartz scheduler.", force: :cascade do |t|
    t.string "sched_name", limit: 120, null: false
    t.string "trigger_name", limit: 200, null: false
    t.string "trigger_group", limit: 200, null: false
    t.string "str_prop_1", limit: 512
    t.string "str_prop_2", limit: 512
    t.string "str_prop_3", limit: 512
    t.integer "int_prop_1"
    t.integer "int_prop_2"
    t.bigint "long_prop_1"
    t.bigint "long_prop_2"
    t.decimal "dec_prop_1", precision: 13, scale: 4
    t.decimal "dec_prop_2", precision: 13, scale: 4
    t.boolean "bool_prop_1"
    t.boolean "bool_prop_2"
  end

  create_table "qrtz_triggers", primary_key: ["sched_name", "trigger_name", "trigger_group"], comment: "Used for Quartz scheduler.", force: :cascade do |t|
    t.string "sched_name", limit: 120, null: false
    t.string "trigger_name", limit: 200, null: false
    t.string "trigger_group", limit: 200, null: false
    t.string "job_name", limit: 200, null: false
    t.string "job_group", limit: 200, null: false
    t.string "description", limit: 250
    t.bigint "next_fire_time"
    t.bigint "prev_fire_time"
    t.integer "priority"
    t.string "trigger_state", limit: 16, null: false
    t.string "trigger_type", limit: 8, null: false
    t.bigint "start_time", null: false
    t.bigint "end_time"
    t.string "calendar_name", limit: 200
    t.integer "misfire_instr", limit: 2
    t.binary "job_data"
    t.index ["sched_name", "calendar_name"], name: "idx_qrtz_t_c"
    t.index ["sched_name", "job_group"], name: "idx_qrtz_t_jg"
    t.index ["sched_name", "job_name", "job_group"], name: "idx_qrtz_t_j"
    t.index ["sched_name", "misfire_instr", "next_fire_time", "trigger_group", "trigger_state"], name: "idx_qrtz_t_nft_st_misfire_grp"
    t.index ["sched_name", "misfire_instr", "next_fire_time", "trigger_state"], name: "idx_qrtz_t_nft_st_misfire"
    t.index ["sched_name", "misfire_instr", "next_fire_time"], name: "idx_qrtz_t_nft_misfire"
    t.index ["sched_name", "next_fire_time"], name: "idx_qrtz_t_next_fire_time"
    t.index ["sched_name", "trigger_group", "trigger_state"], name: "idx_qrtz_t_n_g_state"
    t.index ["sched_name", "trigger_group"], name: "idx_qrtz_t_g"
    t.index ["sched_name", "trigger_name", "trigger_group", "trigger_state"], name: "idx_qrtz_t_n_state"
    t.index ["sched_name", "trigger_state", "next_fire_time"], name: "idx_qrtz_t_nft_st"
    t.index ["sched_name", "trigger_state"], name: "idx_qrtz_t_state"
  end

  create_table "query", primary_key: "query_hash", id: :binary, comment: "The hash of the query dictionary. (This is a 256-bit SHA3 hash of the query dict.)", comment: "Information (such as average execution time) for different queries that have been previously ran.", force: :cascade do |t|
    t.integer "average_execution_time", null: false, comment: "Average execution time for the query, round to nearest number of milliseconds. This is updated as a rolling average."
    t.text "query", comment: "The actual \"query dictionary\" for this query."
  end

  create_table "query_cache", primary_key: "query_hash", id: :binary, comment: "The hash of the query dictionary. (This is a 256-bit SHA3 hash of the query dict).", comment: "Cached results of queries are stored here when using the DB-based query cache.", force: :cascade do |t|
    t.datetime "updated_at", null: false, comment: "The timestamp of when these query results were last refreshed."
    t.binary "results", null: false, comment: "Cached, compressed results of running the query with the given hash."
    t.index ["updated_at"], name: "idx_query_cache_updated_at"
  end

  create_table "query_execution", id: :serial, comment: "A log of executed queries, used for calculating historic execution times, auditing, and other purposes.", force: :cascade do |t|
    t.binary "hash", null: false, comment: "The hash of the query dictionary. This is a 256-bit SHA3 hash of the query."
    t.datetime "started_at", null: false, comment: "Timestamp of when this query started running."
    t.integer "running_time", null: false, comment: "The time, in milliseconds, this query took to complete."
    t.integer "result_rows", null: false, comment: "Number of rows in the query results."
    t.boolean "native", null: false, comment: "Whether the query was a native query, as opposed to an MBQL one (e.g., created with the GUI)."
    t.string "context", limit: 32, comment: "Short string specifying how this query was executed, e.g. in a Dashboard or Pulse."
    t.text "error", comment: "Error message returned by failed query, if any."
    t.integer "executor_id", comment: "The ID of the User who triggered this query execution, if any."
    t.integer "card_id", comment: "The ID of the Card (Question) associated with this query execution, if any."
    t.integer "dashboard_id", comment: "The ID of the Dashboard associated with this query execution, if any."
    t.integer "pulse_id", comment: "The ID of the Pulse associated with this query execution, if any."
    t.integer "database_id", comment: "ID of the database this query was ran against."
    t.index ["hash", "started_at"], name: "idx_query_execution_query_hash_started_at"
    t.index ["started_at"], name: "idx_query_execution_started_at"
  end

  create_table "report_card", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", limit: 254, null: false
    t.text "description"
    t.string "display", limit: 254, null: false
    t.text "dataset_query", null: false
    t.text "visualization_settings", null: false
    t.integer "creator_id", null: false
    t.integer "database_id"
    t.integer "table_id"
    t.string "query_type", limit: 16
    t.boolean "archived", default: false, null: false
    t.integer "collection_id", comment: "Optional ID of Collection this Card belongs to."
    t.string "public_uuid", limit: 36, comment: "Unique UUID used to in publically-accessible links to this Card."
    t.integer "made_public_by_id", comment: "The ID of the User who first publically shared this Card."
    t.boolean "enable_embedding", default: false, null: false, comment: "Is this Card allowed to be embedded in different websites (using a signed JWT)?"
    t.text "embedding_params", comment: "Serialized JSON containing information about required parameters that must be supplied when embedding this Card."
    t.integer "cache_ttl", comment: "The maximum time, in seconds, to return cached results for this Card rather than running a new query."
    t.text "result_metadata", comment: "Serialized JSON containing metadata about the result columns from running the query."
    t.integer "collection_position", limit: 2, comment: "Optional pinned position for this item in its Collection. NULL means item is not pinned."
    t.index ["collection_id"], name: "idx_card_collection_id"
    t.index ["creator_id"], name: "idx_card_creator_id"
    t.index ["public_uuid"], name: "idx_card_public_uuid"
    t.index ["public_uuid"], name: "report_card_public_uuid_key", unique: true
  end

  create_table "report_cardfavorite", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "card_id", null: false
    t.integer "owner_id", null: false
    t.index ["card_id", "owner_id"], name: "idx_unique_cardfavorite_card_id_owner_id", unique: true
    t.index ["card_id"], name: "idx_cardfavorite_card_id"
    t.index ["owner_id"], name: "idx_cardfavorite_owner_id"
  end

  create_table "report_dashboard", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", limit: 254, null: false
    t.text "description"
    t.integer "creator_id", null: false
    t.text "parameters", null: false
    t.text "points_of_interest"
    t.text "caveats"
    t.boolean "show_in_getting_started", default: false, null: false
    t.string "public_uuid", limit: 36, comment: "Unique UUID used to in publically-accessible links to this Dashboard."
    t.integer "made_public_by_id", comment: "The ID of the User who first publically shared this Dashboard."
    t.boolean "enable_embedding", default: false, null: false, comment: "Is this Dashboard allowed to be embedded in different websites (using a signed JWT)?"
    t.text "embedding_params", comment: "Serialized JSON containing information about required parameters that must be supplied when embedding this Dashboard."
    t.boolean "archived", default: false, null: false, comment: "Is this Dashboard archived (effectively treated as deleted?)"
    t.integer "position", comment: "The position this Dashboard should appear in the Dashboards list, lower-numbered positions appearing before higher numbered ones."
    t.integer "collection_id", comment: "Optional ID of Collection this Dashboard belongs to."
    t.integer "collection_position", limit: 2, comment: "Optional pinned position for this item in its Collection. NULL means item is not pinned."
    t.index ["collection_id"], name: "idx_dashboard_collection_id"
    t.index ["creator_id"], name: "idx_dashboard_creator_id"
    t.index ["public_uuid"], name: "idx_dashboard_public_uuid"
    t.index ["public_uuid"], name: "report_dashboard_public_uuid_key", unique: true
    t.index ["show_in_getting_started"], name: "idx_report_dashboard_show_in_getting_started"
  end

  create_table "report_dashboardcard", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "sizeX", null: false
    t.integer "sizeY", null: false
    t.integer "row", default: 0, null: false
    t.integer "col", default: 0, null: false
    t.integer "card_id"
    t.integer "dashboard_id", null: false
    t.text "parameter_mappings", null: false
    t.text "visualization_settings", null: false
    t.index ["card_id"], name: "idx_dashboardcard_card_id"
    t.index ["dashboard_id"], name: "idx_dashboardcard_dashboard_id"
  end

  create_table "revision", id: :serial, force: :cascade do |t|
    t.string "model", limit: 16, null: false
    t.integer "model_id", null: false
    t.integer "user_id", null: false
    t.datetime "timestamp", null: false
    t.string "object", null: false
    t.boolean "is_reversion", default: false, null: false
    t.boolean "is_creation", default: false, null: false
    t.text "message"
    t.index ["model", "model_id"], name: "idx_revision_model_model_id"
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
    t.string "category"
    t.string "zone"
    t.string "level"
    t.string "city"
    t.string "state"
  end

  create_table "segment", id: :serial, force: :cascade do |t|
    t.integer "table_id", null: false
    t.integer "creator_id", null: false
    t.string "name", limit: 254, null: false
    t.text "description"
    t.boolean "archived", default: false, null: false
    t.text "definition", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "points_of_interest"
    t.text "caveats"
    t.boolean "show_in_getting_started", default: false, null: false
    t.index ["creator_id"], name: "idx_segment_creator_id"
    t.index ["show_in_getting_started"], name: "idx_segment_show_in_getting_started"
    t.index ["table_id"], name: "idx_segment_table_id"
  end

  create_table "setting", primary_key: "key", id: :string, limit: 254, force: :cascade do |t|
    t.text "value", null: false
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
    t.bigint "syndrome_id"
    t.bigint "message_id"
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
    t.index ["message_id"], name: "index_syndromes_on_message_id"
  end

  create_table "task_history", id: :serial, comment: "Timing and metadata info about background/quartz processes", force: :cascade do |t|
    t.string "task", limit: 254, null: false, comment: "Name of the task"
    t.integer "db_id"
    t.datetime "started_at", null: false
    t.datetime "ended_at", null: false
    t.integer "duration", null: false
    t.text "task_details", comment: "JSON string with additional info on the task"
    t.index ["db_id"], name: "idx_task_history_db_id"
    t.index ["ended_at"], name: "idx_task_history_end_time"
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
    t.bigint "school_unit_id"
    t.index ["app_id"], name: "index_users_on_app_id"
    t.index ["deleted_at"], name: "index_users_on_deleted_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["group_id"], name: "index_users_on_group_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["school_unit_id"], name: "index_users_on_school_unit_id"
  end

  create_table "view_log", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.string "model", limit: 16, null: false
    t.integer "model_id", null: false
    t.datetime "timestamp", null: false
    t.index ["model_id"], name: "idx_view_log_timestamp"
    t.index ["user_id"], name: "idx_view_log_user_id"
  end

  add_foreign_key "activity", "core_user", column: "user_id", name: "fk_activity_ref_user_id", on_delete: :cascade
  add_foreign_key "admins", "apps"
  add_foreign_key "card_label", "label", name: "fk_card_label_ref_label_id", on_delete: :cascade
  add_foreign_key "card_label", "report_card", column: "card_id", name: "fk_card_label_ref_card_id", on_delete: :cascade
  add_foreign_key "collection", "core_user", column: "personal_owner_id", name: "fk_collection_personal_owner_id", on_delete: :cascade
  add_foreign_key "collection_revision", "core_user", column: "user_id", name: "fk_collection_revision_user_id", on_delete: :cascade
  add_foreign_key "computation_job", "core_user", column: "creator_id", name: "fk_computation_job_ref_user_id", on_delete: :cascade
  add_foreign_key "computation_job_result", "computation_job", column: "job_id", name: "fk_computation_result_ref_job_id", on_delete: :cascade
  add_foreign_key "contents", "apps"
  add_foreign_key "core_session", "core_user", column: "user_id", name: "fk_session_ref_user_id", on_delete: :cascade
  add_foreign_key "dashboard_favorite", "core_user", column: "user_id", name: "fk_dashboard_favorite_user_id", on_delete: :cascade
  add_foreign_key "dashboard_favorite", "report_dashboard", column: "dashboard_id", name: "fk_dashboard_favorite_dashboard_id", on_delete: :cascade
  add_foreign_key "dashboardcard_series", "report_card", column: "card_id", name: "fk_dashboardcard_series_ref_card_id", on_delete: :cascade
  add_foreign_key "dashboardcard_series", "report_dashboardcard", column: "dashboardcard_id", name: "fk_dashboardcard_series_ref_dashboardcard_id", on_delete: :cascade
  add_foreign_key "dimension", "metabase_field", column: "field_id", name: "fk_dimension_ref_field_id", on_delete: :cascade
  add_foreign_key "dimension", "metabase_field", column: "human_readable_field_id", name: "fk_dimension_displayfk_ref_field_id", on_delete: :cascade
  add_foreign_key "group_managers", "apps"
  add_foreign_key "group_table_access_policy", "metabase_table", column: "table_id", name: "fk_gtap_table_id", on_delete: :cascade
  add_foreign_key "group_table_access_policy", "permissions_group", column: "group_id", name: "fk_gtap_group_id", on_delete: :cascade
  add_foreign_key "group_table_access_policy", "report_card", column: "card_id", name: "fk_gtap_card_id", on_delete: :cascade
  add_foreign_key "households", "school_units"
  add_foreign_key "households", "users"
  add_foreign_key "manager_group_permissions", "group_managers"
  add_foreign_key "manager_group_permissions", "groups"
  add_foreign_key "messages", "symptoms"
  add_foreign_key "messages", "syndromes"
  add_foreign_key "metabase_field", "metabase_field", column: "parent_id", name: "fk_field_parent_ref_field_id", on_delete: :cascade
  add_foreign_key "metabase_field", "metabase_table", column: "table_id", name: "fk_field_ref_table_id", on_delete: :cascade
  add_foreign_key "metabase_fieldvalues", "metabase_field", column: "field_id", name: "fk_fieldvalues_ref_field_id", on_delete: :cascade
  add_foreign_key "metabase_table", "metabase_database", column: "db_id", name: "fk_table_ref_database_id", on_delete: :cascade
  add_foreign_key "metric", "core_user", column: "creator_id", name: "fk_metric_ref_creator_id", on_delete: :cascade
  add_foreign_key "metric", "metabase_table", column: "table_id", name: "fk_metric_ref_table_id", on_delete: :cascade
  add_foreign_key "metric_important_field", "metabase_field", column: "field_id", name: "fk_metric_important_field_metabase_field_id", on_delete: :cascade
  add_foreign_key "metric_important_field", "metric", name: "fk_metric_important_field_metric_id", on_delete: :cascade
  add_foreign_key "native_query_snippet", "collection", name: "fk_snippet_collection_id", on_delete: :nullify
  add_foreign_key "native_query_snippet", "core_user", column: "creator_id", name: "fk_snippet_creator_id", on_delete: :cascade
  add_foreign_key "permissions", "permissions_group", column: "group_id", name: "fk_permissions_group_id", on_delete: :cascade
  add_foreign_key "permissions_group_membership", "core_user", column: "user_id", name: "fk_permissions_group_membership_user_id", on_delete: :cascade
  add_foreign_key "permissions_group_membership", "permissions_group", column: "group_id", name: "fk_permissions_group_group_id", on_delete: :cascade
  add_foreign_key "permissions_revision", "core_user", column: "user_id", name: "fk_permissions_revision_user_id", on_delete: :cascade
  add_foreign_key "pre_registers", "apps"
  add_foreign_key "public_hospitals", "apps"
  add_foreign_key "pulse", "collection", name: "fk_pulse_collection_id", on_delete: :nullify
  add_foreign_key "pulse", "core_user", column: "creator_id", name: "fk_pulse_ref_creator_id", on_delete: :cascade
  add_foreign_key "pulse_card", "pulse", name: "fk_pulse_card_ref_pulse_id", on_delete: :cascade
  add_foreign_key "pulse_card", "report_card", column: "card_id", name: "fk_pulse_card_ref_card_id", on_delete: :cascade
  add_foreign_key "pulse_channel", "pulse", name: "fk_pulse_channel_ref_pulse_id", on_delete: :cascade
  add_foreign_key "pulse_channel_recipient", "core_user", column: "user_id", name: "fk_pulse_channel_recipient_ref_user_id", on_delete: :cascade
  add_foreign_key "pulse_channel_recipient", "pulse_channel", name: "fk_pulse_channel_recipient_ref_pulse_channel_id", on_delete: :cascade
  add_foreign_key "qrtz_blob_triggers", "qrtz_triggers", column: "sched_name", primary_key: "sched_name", name: "fk_qrtz_blob_triggers_triggers"
  add_foreign_key "qrtz_cron_triggers", "qrtz_triggers", column: "sched_name", primary_key: "sched_name", name: "fk_qrtz_cron_triggers_triggers"
  add_foreign_key "qrtz_simple_triggers", "qrtz_triggers", column: "sched_name", primary_key: "sched_name", name: "fk_qrtz_simple_triggers_triggers"
  add_foreign_key "qrtz_simprop_triggers", "qrtz_triggers", column: "sched_name", primary_key: "sched_name", name: "fk_qrtz_simprop_triggers_triggers"
  add_foreign_key "qrtz_triggers", "qrtz_job_details", column: "sched_name", primary_key: "sched_name", name: "fk_qrtz_triggers_job_details"
  add_foreign_key "report_card", "collection", name: "fk_card_collection_id", on_delete: :nullify
  add_foreign_key "report_card", "core_user", column: "creator_id", name: "fk_card_ref_user_id", on_delete: :cascade
  add_foreign_key "report_card", "core_user", column: "made_public_by_id", name: "fk_card_made_public_by_id", on_delete: :cascade
  add_foreign_key "report_card", "metabase_database", column: "database_id", name: "fk_report_card_ref_database_id", on_delete: :cascade
  add_foreign_key "report_card", "metabase_table", column: "table_id", name: "fk_report_card_ref_table_id", on_delete: :cascade
  add_foreign_key "report_cardfavorite", "core_user", column: "owner_id", name: "fk_cardfavorite_ref_user_id", on_delete: :cascade
  add_foreign_key "report_cardfavorite", "report_card", column: "card_id", name: "fk_cardfavorite_ref_card_id", on_delete: :cascade
  add_foreign_key "report_dashboard", "collection", name: "fk_dashboard_collection_id", on_delete: :nullify
  add_foreign_key "report_dashboard", "core_user", column: "creator_id", name: "fk_dashboard_ref_user_id", on_delete: :cascade
  add_foreign_key "report_dashboard", "core_user", column: "made_public_by_id", name: "fk_dashboard_made_public_by_id", on_delete: :cascade
  add_foreign_key "report_dashboardcard", "report_card", column: "card_id", name: "fk_dashboardcard_ref_card_id", on_delete: :cascade
  add_foreign_key "report_dashboardcard", "report_dashboard", column: "dashboard_id", name: "fk_dashboardcard_ref_dashboard_id", on_delete: :cascade
  add_foreign_key "revision", "core_user", column: "user_id", name: "fk_revision_ref_user_id", on_delete: :cascade
  add_foreign_key "segment", "core_user", column: "creator_id", name: "fk_segment_ref_creator_id", on_delete: :cascade
  add_foreign_key "segment", "metabase_table", column: "table_id", name: "fk_segment_ref_table_id", on_delete: :cascade
  add_foreign_key "surveys", "households"
  add_foreign_key "surveys", "users"
  add_foreign_key "symptoms", "apps"
  add_foreign_key "symptoms", "messages"
  add_foreign_key "symptoms", "syndromes"
  add_foreign_key "syndrome_symptom_percentages", "symptoms"
  add_foreign_key "syndrome_symptom_percentages", "syndromes"
  add_foreign_key "syndromes", "messages"
  add_foreign_key "users", "apps"
  add_foreign_key "users", "groups"
  add_foreign_key "users", "school_units"
end
