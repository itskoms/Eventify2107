# This file is auto-generated from the current state of the database.

ActiveRecord::Schema[7.2].define(version: 2024_11_20_204731) do
  # Events Table
  create_table "events", force: :cascade do |t|
    t.datetime "start_date", null: false
    t.datetime "end_date", null: false
    t.text "description"
    t.datetime "end_time", null: false
    t.string "location", null: false
    t.datetime "start_time", null: false
    t.string "title", null: false
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_events_on_user_id"
  end

  # Guests Table
  create_table "guests", force: :cascade do |t|
    t.string "role", default: "guest"
    t.string "rsvp_status", default: "pending"
    t.integer "party_size", default: 1
    t.integer "event_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_guests_on_event_id"
    t.index ["user_id"], name: "index_guests_on_user_id"
  end

  # Users Table
  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest", default: "", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "phone_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  # Foreign Key Constraints
  add_foreign_key "events", "users"
  add_foreign_key "guests", "events"
  add_foreign_key "guests", "users"
end
