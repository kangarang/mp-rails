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

ActiveRecord::Schema.define(version: 20170622053922) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "artists", force: :cascade do |t|
    t.string "name"
    t.integer "aid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["aid"], name: "index_artists_on_aid"
  end

  create_table "artists_users", id: false, force: :cascade do |t|
    t.bigint "artist_id", null: false
    t.bigint "user_id", null: false
  end

  create_table "blacklistings", force: :cascade do |t|
    t.integer "user_id"
    t.integer "blacklist_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["blacklist_id", "user_id"], name: "index_blacklistings_on_blacklist_id_and_user_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "event_name"
    t.string "date"
    t.string "uri"
    t.string "venue"
    t.string "reason_artist"
    t.integer "eid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["eid"], name: "index_events_on_eid"
  end

  create_table "events_users", id: false, force: :cascade do |t|
    t.bigint "event_id", null: false
    t.bigint "user_id", null: false
  end

  create_table "matchings", force: :cascade do |t|
    t.integer "user_id"
    t.integer "match_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["match_id", "user_id"], name: "index_matchings_on_match_id_and_user_id"
  end

  create_table "potentialings", force: :cascade do |t|
    t.integer "user_id"
    t.integer "potential_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["potential_id", "user_id"], name: "index_potentialings_on_potential_id_and_user_id"
  end

  create_table "rooms", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rooms_users", id: false, force: :cascade do |t|
    t.bigint "room_id", null: false
    t.bigint "user_id", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "songkick_username"
    t.string "gender"
    t.string "location"
    t.string "seeking"
    t.string "height"
    t.string "ethnicity"
    t.string "eth_pref"
    t.string "body_type"
    t.string "profession"
    t.string "photo_url"
    t.string "uid"
    t.boolean "also_friends"
    t.boolean "just_friends"
    t.integer "age"
    t.integer "age_pref_low"
    t.integer "age_pref_high"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["age", "gender", "seeking"], name: "index_users_on_age_and_gender_and_seeking"
    t.index ["uid"], name: "index_users_on_uid"
  end

end
