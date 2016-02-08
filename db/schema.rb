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

ActiveRecord::Schema.define(version: 20160208010827) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ahoy_events", id: :uuid, default: nil, force: :cascade do |t|
    t.uuid     "visit_id"
    t.integer  "user_id"
    t.string   "name",       limit: 255
    t.json     "properties"
    t.datetime "time"
  end

  add_index "ahoy_events", ["time"], name: "index_ahoy_events_on_time", using: :btree
  add_index "ahoy_events", ["user_id"], name: "index_ahoy_events_on_user_id", using: :btree
  add_index "ahoy_events", ["visit_id"], name: "index_ahoy_events_on_visit_id", using: :btree

  create_table "authorizations", force: :cascade do |t|
    t.string   "provider",      limit: 255
    t.string   "uid",           limit: 255
    t.integer  "user_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "token",         limit: 255
    t.string   "secret",        limit: 255
    t.datetime "token_expires"
    t.string   "temp_token",    limit: 255
  end

  add_index "authorizations", ["user_id"], name: "index_authorizations_on_user_id", using: :btree

  create_table "categories", force: :cascade do |t|
    t.string   "title",      limit: 255
    t.string   "color",                  default: "#ccc", null: false
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
  end

  create_table "comments", force: :cascade do |t|
    t.text     "body"
    t.integer  "user_id"
    t.integer  "commentable_id"
    t.string   "commentable_type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["commentable_id", "commentable_type"], name: "index_comments_on_commentable_id_and_commentable_type", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "event_curations", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "event_curations", ["event_id"], name: "index_event_curations_on_event_id", using: :btree
  add_index "event_curations", ["user_id"], name: "index_event_curations_on_user_id", using: :btree

  create_table "events", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.text     "description"
    t.text     "schedule_yaml"
    t.string   "url",             limit: 255
    t.string   "twitter",         limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "full_day",                    default: false
    t.string   "twitter_hashtag", limit: 255
    t.integer  "category_id"
    t.integer  "venue_id"
    t.string   "venue_info",      limit: 255
    t.integer  "picture_id"
    t.integer  "region_id"
  end

  add_index "events", ["category_id"], name: "index_events_on_category_id", using: :btree
  add_index "events", ["picture_id"], name: "index_events_on_picture_id", using: :btree
  add_index "events", ["region_id"], name: "index_events_on_region_id", using: :btree
  add_index "events", ["venue_id"], name: "index_events_on_venue_id", using: :btree

  create_table "pictures", force: :cascade do |t|
    t.string   "title",       limit: 255
    t.text     "description"
    t.string   "box_image",   limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "radar_entries", force: :cascade do |t|
    t.integer  "radar_setting_id"
    t.string   "entry_id",                   limit: 255
    t.datetime "entry_date"
    t.string   "state",                      limit: 255
    t.text     "content"
    t.text     "previous_confirmed_content"
    t.string   "entry_type",                 limit: 255
  end

  create_table "radar_settings", force: :cascade do |t|
    t.integer  "event_id"
    t.string   "url",            limit: 255
    t.string   "radar_type",     limit: 255
    t.datetime "last_processed"
    t.string   "last_result",    limit: 255
  end

  create_table "region_organizers", force: :cascade do |t|
    t.integer  "region_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "region_organizers", ["region_id"], name: "index_region_organizers_on_region_id", using: :btree
  add_index "region_organizers", ["user_id"], name: "index_region_organizers_on_user_id", using: :btree

  create_table "regions", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "slug",       limit: 255
    t.float    "latitude"
    t.float    "longitude"
    t.float    "perimeter",              default: 20.0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active"
  end

  add_index "regions", ["slug"], name: "index_regions_on_slug", using: :btree

  create_table "single_event_external_users", force: :cascade do |t|
    t.integer  "single_event_id"
    t.string   "email",           limit: 255
    t.string   "name",            limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "session_token",   limit: 255
  end

  add_index "single_event_external_users", ["single_event_id"], name: "index_single_event_external_users_on_single_event_id", using: :btree

  create_table "single_events", force: :cascade do |t|
    t.string   "name",                    limit: 255
    t.text     "description"
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "occurrence"
    t.string   "url",                     limit: 255
    t.integer  "duration"
    t.boolean  "full_day"
    t.string   "twitter_hashtag",         limit: 255
    t.boolean  "based_on_rule",                       default: false
    t.integer  "category_id"
    t.integer  "venue_id"
    t.string   "venue_info",              limit: 255
    t.integer  "picture_id"
    t.string   "twitter",                 limit: 255
    t.boolean  "use_venue_info_of_event",             default: true
    t.integer  "region_id"
  end

  add_index "single_events", ["category_id"], name: "index_single_events_on_category_id", using: :btree
  add_index "single_events", ["event_id"], name: "index_single_events_on_event_id", using: :btree
  add_index "single_events", ["picture_id"], name: "index_single_events_on_picture_id", using: :btree
  add_index "single_events", ["region_id"], name: "index_single_events_on_region_id", using: :btree
  add_index "single_events", ["venue_id"], name: "index_single_events_on_venue_id", using: :btree

  create_table "single_events_users", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "single_event_id"
  end

  add_index "single_events_users", ["single_event_id"], name: "index_single_events_users_on_single_event_id", using: :btree
  add_index "single_events_users", ["user_id"], name: "index_single_events_users_on_user_id", using: :btree

  create_table "suggestions", force: :cascade do |t|
    t.text     "description"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "email_address", limit: 255
  end

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type", limit: 255
    t.integer  "tagger_id"
    t.string   "tagger_type",   limit: 255
    t.string   "context",       limit: 255
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string  "name",           limit: 255
    t.integer "category_id"
    t.integer "taggings_count",             default: 0
  end

  add_index "tags", ["category_id"], name: "index_tags_on_category_id", using: :btree
  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255
    t.string   "encrypted_password",     limit: 255
    t.string   "reset_password_token",   limit: 255
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin",                              default: false
    t.string   "nickname",               limit: 255, default: "",    null: false
    t.text     "description"
    t.string   "github",                 limit: 255
    t.string   "twitter",                limit: 255
    t.string   "homepage",               limit: 255
    t.string   "guid",                   limit: 255
    t.boolean  "allow_ignore_view"
    t.datetime "reset_password_sent_at"
    t.string   "image_url",              limit: 255
    t.string   "team",                   limit: 255
    t.string   "name",                   limit: 255
    t.integer  "current_region_id",                  default: 2
    t.string   "gravatar_email",         limit: 255
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["nickname"], name: "index_users_on_nickname", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "venues", force: :cascade do |t|
    t.string   "location",   limit: 255
    t.string   "street",     limit: 255
    t.string   "zipcode",    limit: 255
    t.string   "city",       limit: 255
    t.string   "country",    limit: 255
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "url",        limit: 255
    t.integer  "region_id",              default: 2
  end

  add_index "venues", ["latitude", "longitude"], name: "index_venues_on_latitude_and_longitude", using: :btree
  add_index "venues", ["region_id"], name: "index_venues_on_region_id", using: :btree

  create_table "visits", id: :uuid, default: nil, force: :cascade do |t|
    t.uuid     "visitor_id"
    t.string   "ip",               limit: 255
    t.text     "user_agent"
    t.text     "referrer"
    t.text     "landing_page"
    t.integer  "user_id"
    t.string   "referring_domain", limit: 255
    t.string   "search_keyword",   limit: 255
    t.string   "browser",          limit: 255
    t.string   "os",               limit: 255
    t.string   "device_type",      limit: 255
    t.string   "country",          limit: 255
    t.string   "region",           limit: 255
    t.string   "city",             limit: 255
    t.string   "utm_source",       limit: 255
    t.string   "utm_medium",       limit: 255
    t.string   "utm_term",         limit: 255
    t.string   "utm_content",      limit: 255
    t.string   "utm_campaign",     limit: 255
    t.string   "platform",         limit: 255
    t.string   "app_version",      limit: 255
    t.string   "os_version",       limit: 255
    t.datetime "started_at"
  end

  add_index "visits", ["user_id"], name: "index_visits_on_user_id", using: :btree

end
