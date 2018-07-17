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

ActiveRecord::Schema.define(version: 0) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "attendee", primary_key: ["user_id", "event_id"], force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "event_id", null: false
  end

  create_table "events", id: :integer, default: nil, force: :cascade do |t|
    t.date "date", null: false
    t.integer "location_id", null: false
    t.text "title", null: false
    t.text "description"
  end

  create_table "host", primary_key: ["user_id", "event_id"], force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "event_id", null: false
  end

  create_table "locations", id: :integer, default: nil, force: :cascade do |t|
    t.text "address_1", null: false
    t.text "address_2", null: false
    t.text "city", null: false
    t.text "state", null: false
    t.integer "postal_code", null: false
  end

  create_table "tasks", id: :integer, default: nil, force: :cascade do |t|
    t.boolean "status", null: false
    t.text "description", null: false
    t.integer "user_id", null: false
    t.integer "event_id"
  end

  create_table "users", id: :integer, default: nil, force: :cascade do |t|
    t.text "first_name", null: false
    t.text "last_name", null: false
    t.text "email", null: false
    t.text "password", null: false
  end

  add_foreign_key "attendee", "events", name: "attendee_event_id_fkey"
  add_foreign_key "attendee", "users", name: "attendee_user_id_fkey"
  add_foreign_key "events", "locations", name: "events_location_id_fkey"
  add_foreign_key "host", "events", name: "host_event_id_fkey"
  add_foreign_key "host", "users", name: "host_user_id_fkey"
  add_foreign_key "tasks", "events", name: "tasks_event_id_fkey"
  add_foreign_key "tasks", "users", name: "tasks_user_id_fkey"
end
