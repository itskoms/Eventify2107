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

ActiveRecord::Schema[7.2].define(version: 2024_11_20_204731) do
  create_table "events", force: :cascade do |t|
    t.datetime "date"
    t.text "description"
    t.datetime "end_time"
    t.string "location"
    t.datetime "start_time"
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "events_guests", id: false, force: :cascade do |t|
    t.integer "event_id", null: false
    t.integer "guest_id", null: false
    t.index ["event_id", "guest_id"], name: "index_events_guests_on_event_id_and_guest_id"
    t.index ["guest_id", "event_id"], name: "index_events_guests_on_guest_id_and_event_id"
  end

  create_table "guest_lists", force: :cascade do |t|
    t.string "rsvp_status"
    t.integer "event_id", null: false
    t.integer "guest_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_guest_lists_on_event_id"
    t.index ["guest_id"], name: "index_guest_lists_on_guest_id"
  end

  create_table "guests", force: :cascade do |t|
    t.string "email", null: false
    t.string "first_name"
    t.string "last_name"
    t.integer "party_size"
    t.string "password_digest", default: "", null: false
    t.string "phone"
    t.integer "event_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_guests_on_event_id"
  end

  create_table "organizers", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "password_digest", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest", default: "", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "phone_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "guest_lists", "events"
  add_foreign_key "guest_lists", "guests"
  add_foreign_key "guests", "events"
end
