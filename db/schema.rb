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

ActiveRecord::Schema.define(version: 20131124162300) do

  create_table "feedback_events", force: true do |t|
    t.integer  "submission_event_id", null: false
    t.boolean  "accepted",            null: false
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "feedback_events", ["submission_event_id"], name: "index_feedback_events_on_submission_event_id"

  create_table "final_reports", force: true do |t|
    t.string "aasm_state"
  end

  create_table "log_events", force: true do |t|
    t.integer  "user_id",      null: false
    t.integer  "task_id",      null: false
    t.integer  "details_id",   null: false
    t.string   "details_type", null: false
    t.datetime "created_at"
  end

  add_index "log_events", ["details_id", "details_type"], name: "index_log_events_on_details_id_and_details_type"
  add_index "log_events", ["task_id"], name: "index_log_events_on_task_id"
  add_index "log_events", ["user_id"], name: "index_log_events_on_user_id"

  create_table "oral_presentation_forms", force: true do |t|
    t.string "aasm_state"
    t.text   "available_times"
    t.text   "accepted_user_ids"
  end

  create_table "programmes", force: true do |t|
    t.integer  "project_id"
    t.string   "programme"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "progress_reports", force: true do |t|
    t.string "aasm_state"
  end

  create_table "projects", force: true do |t|
    t.string   "aasm_state"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects_users", force: true do |t|
    t.integer "user_id",    null: false
    t.integer "project_id", null: false
  end

  add_index "projects_users", ["project_id"], name: "index_projects_users_on_project_id"
  add_index "projects_users", ["user_id", "project_id"], name: "index_projects_users_on_user_id_and_project_id", unique: true
  add_index "projects_users", ["user_id"], name: "index_projects_users_on_user_id"

  create_table "proposals", force: true do |t|
    t.string "aasm_state"
  end

  create_table "submission_events", force: true do |t|
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tasks", force: true do |t|
    t.integer  "project_id"
    t.string   "taskable_type"
    t.integer  "taskable_id"
    t.string   "summary"
    t.datetime "deadline"
    t.datetime "completed_at"
  end

  add_index "tasks", ["project_id"], name: "index_tasks_on_project_id"

  create_table "users", force: true do |t|
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
    t.string   "full_name"
    t.string   "role"
    t.string   "programme"
    t.string   "student_number"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["project_id"], name: "index_users_on_project_id"
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
