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

ActiveRecord::Schema[8.0].define(version: 2025_06_12_125740) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "applications", force: :cascade do |t|
    t.bigint "task_id", null: false
    t.bigint "supporter_id", null: false
    t.string "application_status"
    t.string "request_status"
    t.text "comment_supporter"
    t.text "comment_organization"
    t.text "experience"
    t.string "uptime"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["supporter_id"], name: "index_applications_on_supporter_id"
    t.index ["task_id"], name: "index_applications_on_task_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "notification_type"
    t.string "title"
    t.text "body"
    t.bigint "related_task_id"
    t.bigint "related_application_id"
    t.boolean "is_read", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["related_application_id"], name: "index_notifications_on_related_application_id"
    t.index ["related_task_id"], name: "index_notifications_on_related_task_id"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "organizations", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tasks", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.date "apply_deadline"
    t.integer "required_number_of_people"
    t.string "status"
    t.bigint "organization_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_tasks_on_organization_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "mail_address"
    t.string "role"
    t.bigint "organization_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.string "registration_token"
    t.datetime "registration_token_sent_at"
    t.index ["organization_id"], name: "index_users_on_organization_id"
    t.index ["registration_token"], name: "index_users_on_registration_token", unique: true
  end

  add_foreign_key "applications", "tasks"
  add_foreign_key "applications", "users", column: "supporter_id"
  add_foreign_key "notifications", "applications", column: "related_application_id"
  add_foreign_key "notifications", "tasks", column: "related_task_id"
  add_foreign_key "notifications", "users"
  add_foreign_key "tasks", "organizations"
  add_foreign_key "users", "organizations"
end
