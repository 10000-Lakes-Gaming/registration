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

ActiveRecord::Schema.define(version: 2019_09_13_225352) do

  create_table "additional_payments", force: :cascade do |t|
    t.string "category"
    t.string "description"
    t.boolean "charitable_donation", default: false
    t.integer "market_price", default: 0
    t.integer "payment_price", default: 0
    t.integer "payment_amount"
    t.string "payment_id"
    t.datetime "payment_date"
    t.integer "user_event_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_event_id"], name: "index_additional_payments_on_user_event_id"
  end

  create_table "event_hosts", force: :cascade do |t|
    t.date "start_date"
    t.date "end_date"
    t.integer "user_id"
    t.integer "event_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_event_hosts_on_event_id"
    t.index ["user_id"], name: "index_event_hosts_on_user_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "name"
    t.datetime "start"
    t.datetime "end"
    t.string "location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "rsvp_close"
    t.boolean "charity"
    t.integer "prereg_price", default: 0
    t.string "info"
    t.string "external_url"
    t.integer "event_number"
    t.integer "onsite_price", default: 0
    t.datetime "prereg_ends"
    t.string "gm_volunteer_link"
    t.datetime "online_sales_end"
  end

  create_table "game_masters", force: :cascade do |t|
    t.integer "table_id"
    t.integer "user_event_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "table_number"
    t.index ["table_id"], name: "index_game_masters_on_table_id"
    t.index ["user_event_id"], name: "index_game_masters_on_user_event_id"
  end

  create_table "registration_tables", force: :cascade do |t|
    t.integer "table_id"
    t.integer "user_event_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "paid", default: false
    t.integer "payment_amount"
    t.string "payment_id"
    t.datetime "payment_date"
    t.integer "seat"
  end

  create_table "scenarios", force: :cascade do |t|
    t.string "type_of"
    t.integer "season"
    t.integer "scenario_number"
    t.string "name"
    t.string "description"
    t.string "author"
    t.string "paizo_url"
    t.boolean "hard_mode"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "pregen_only"
    t.string "tier"
    t.boolean "retired", default: false
    t.string "game_system", default: "PFS"
    t.boolean "evergreen"
  end

  create_table "sessions", force: :cascade do |t|
    t.integer "event_id"
    t.string "name"
    t.datetime "start"
    t.datetime "end"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_sessions_on_event_id"
  end

  create_table "tables", force: :cascade do |t|
    t.integer "session_id"
    t.integer "scenario_id"
    t.integer "max_players"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "gms_needed", default: 1
    t.boolean "raffle", default: false
    t.boolean "core", default: false
    t.string "location"
    t.boolean "premium"
    t.integer "prereg_price", default: 0
    t.integer "onsite_price", default: 0
    t.boolean "disabled", default: false
    t.boolean "non_pfs"
    t.string "information"
    t.boolean "gm_self_select", default: true
    t.index ["scenario_id"], name: "index_tables_on_scenario_id"
    t.index ["session_id"], name: "index_tables_on_session_id"
  end

  create_table "user_events", force: :cascade do |t|
    t.integer "user_id"
    t.integer "event_id"
    t.boolean "paid", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "payment_id"
    t.integer "payment_amount"
    t.datetime "payment_date"
    t.boolean "vip"
    t.index ["event_id"], name: "index_user_events_on_event_id"
    t.index ["user_id"], name: "index_user_events_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.integer "pfs_number"
    t.boolean "admin"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "forum_username"
    t.integer "gm_stars"
    t.boolean "venture_officer"
    t.string "title"
    t.decimal "dci_number"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["pfs_number"], name: "index_users_on_pfs_number", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
