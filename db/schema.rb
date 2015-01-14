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

ActiveRecord::Schema.define(version: 20150113032409) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "batches", force: :cascade do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "started",    default: false
  end

  create_table "batches_clients", id: false, force: :cascade do |t|
    t.integer "batch_id"
    t.integer "client_id"
  end

  add_index "batches_clients", ["batch_id"], name: "index_batches_clients_on_batch_id", using: :btree
  add_index "batches_clients", ["client_id"], name: "index_batches_clients_on_client_id", using: :btree

  create_table "client_batches", force: :cascade do |t|
    t.integer  "client_id"
    t.integer  "batch_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "client_steps", force: :cascade do |t|
    t.integer  "client_id"
    t.integer  "step_id"
    t.string   "client_guid"
    t.text     "standard_output"
    t.text     "standard_error"
    t.boolean  "has_exited"
    t.integer  "exit_code"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "error"
    t.string   "callback_token"
    t.boolean  "fatally_errored", default: false
  end

  create_table "clients", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "display_name"
    t.string   "agent_endpoint_url"
    t.string   "type"
    t.integer  "skytap_vm_id"
    t.string   "skytap_config_url"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "commands", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.string   "path"
    t.string   "args"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "steps", force: :cascade do |t|
    t.integer  "batch_id"
    t.integer  "command_id"
    t.integer  "index"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                      default: "", null: false
    t.string   "encrypted_password",         default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",              default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",            default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "rcx_skytap_username"
    t.string   "rcx_skytap_api_token"
    t.string   "authentication_token"
    t.datetime "clients_update_started_at"
    t.datetime "clients_update_finished_at"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

end
