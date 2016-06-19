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

ActiveRecord::Schema.define(version: 20160511182201) do

  create_table "events", force: :cascade do |t|
    t.string   "name"
    t.datetime "start"
    t.datetime "end"
    t.string   "location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "scenarios", force: :cascade do |t|
    t.string   "type"
    t.integer  "season"
    t.integer  "scenario_number"
    t.string   "name"
    t.string   "description"
    t.string   "author"
    t.string   "paizo_url"
    t.boolean  "hard_mode"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.boolean  "pregen_only"
  end

  create_table "sessions", force: :cascade do |t|
    t.integer  "event_id"
    t.string   "name"
    t.datetime "start"
    t.datetime "end"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "sessions", ["event_id"], name: "index_sessions_on_event_id"

  create_table "tables", force: :cascade do |t|
    t.integer  "session_id"
    t.integer  "scenario_id"
    t.integer  "max_players"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "tables", ["scenario_id"], name: "index_tables_on_scenario_id"
  add_index "tables", ["session_id"], name: "index_tables_on_session_id"

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "name"
    t.string   "email_address"
    t.integer  "pfs_number"
    t.boolean  "admin"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

end
