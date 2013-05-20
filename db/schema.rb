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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130520081727) do

  create_table "active_admin_comments", :force => true do |t|
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "authorizations", :force => true do |t|
    t.string   "provider"
    t.string   "uid"
    t.integer  "user_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "token"
    t.string   "secret"
    t.datetime "token_expires"
    t.string   "temp_token"
  end

  add_index "authorizations", ["user_id"], :name => "index_authorizations_on_user_id"

  create_table "calendar_preset_categories", :force => true do |t|
    t.integer  "category_id"
    t.integer  "calendar_preset_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "calendar_preset_categories", ["calendar_preset_id"], :name => "index_calendar_preset_categories_on_calendar_preset_id"
  add_index "calendar_preset_categories", ["category_id"], :name => "index_calendar_preset_categories_on_category_id"

  create_table "calendar_presets", :force => true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "calendar_presets", ["user_id"], :name => "index_calendar_presets_on_user_id"

  create_table "categories", :force => true do |t|
    t.string   "title"
    t.string   "color"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "comments", :force => true do |t|
    t.text     "body"
    t.integer  "user_id"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["commentable_id", "commentable_type"], :name => "index_comments_on_commentable_id_and_commentable_type"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "event_curations", :force => true do |t|
    t.integer  "user_id"
    t.integer  "event_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "event_curations", ["event_id"], :name => "index_events_users_on_event_id"
  add_index "event_curations", ["user_id"], :name => "index_events_users_on_user_id"

  create_table "events", :force => true do |t|
    t.string   "name"
    t.integer  "region_id"
    t.text     "description"
    t.text     "schedule_yaml"
    t.string   "url"
    t.string   "twitter"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "full_day",        :default => false
    t.string   "twitter_hashtag"
    t.integer  "category_id"
    t.integer  "venue_id"
    t.string   "venue_info"
    t.integer  "picture_id"
  end

  add_index "events", ["category_id"], :name => "index_events_on_category_id"
  add_index "events", ["picture_id"], :name => "index_events_on_picture_id"
  add_index "events", ["region_id"], :name => "index_events_on_region_id"
  add_index "events", ["venue_id"], :name => "index_events_on_venue_id"

  create_table "pictures", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "box_image"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "region_organizers", :force => true do |t|
    t.integer  "region_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "region_organizers", ["region_id"], :name => "index_regions_users_on_region_id"
  add_index "region_organizers", ["user_id"], :name => "index_regions_users_on_user_id"

  create_table "regions", :force => true do |t|
    t.string   "name"
    t.string   "slug"
    t.float    "latitude"
    t.float    "longitude"
    t.float    "perimeter",  :default => 20.0
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  add_index "regions", ["slug"], :name => "index_regions_on_slug"

  create_table "single_events", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "occurrence"
    t.string   "url"
    t.integer  "duration"
    t.boolean  "full_day"
    t.string   "twitter_hashtag"
    t.boolean  "based_on_rule",           :default => false
    t.integer  "category_id"
    t.integer  "venue_id"
    t.string   "venue_info"
    t.integer  "picture_id"
    t.string   "twitter"
    t.boolean  "use_venue_info_of_event", :default => true
  end

  add_index "single_events", ["category_id"], :name => "index_single_events_on_category_id"
  add_index "single_events", ["event_id"], :name => "index_single_events_on_event_id"
  add_index "single_events", ["picture_id"], :name => "index_single_events_on_picture_id"
  add_index "single_events", ["venue_id"], :name => "index_single_events_on_venue_id"

  create_table "single_events_users", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "single_event_id"
  end

  add_index "single_events_users", ["single_event_id"], :name => "index_single_events_users_on_single_event_id"
  add_index "single_events_users", ["user_id"], :name => "index_single_events_users_on_user_id"

  create_table "suggestions", :force => true do |t|
    t.string   "name"
    t.string   "occurrence"
    t.text     "description"
    t.text     "place"
    t.text     "more"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"
  add_index "taggings", ["tagger_id", "tagger_type"], :name => "index_taggings_on_tagger_id_and_tagger_type"

  create_table "tags", :force => true do |t|
    t.string  "name"
    t.integer "category_id"
  end

  add_index "tags", ["category_id"], :name => "index_tags_on_category_id"

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "encrypted_password"
    t.string   "reset_password_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin",                  :default => false
    t.string   "nickname",               :default => "",    :null => false
    t.integer  "current_region_id",      :default => 2
    t.text     "description"
    t.string   "github"
    t.string   "twitter"
    t.string   "homepage"
    t.string   "guid"
    t.boolean  "allow_ignore_view"
    t.datetime "reset_password_sent_at"
    t.string   "image_url"
    t.string   "team"
    t.string   "name"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["nickname"], :name => "index_users_on_nickname", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "venues", :force => true do |t|
    t.string   "location"
    t.integer  "region_id",  :default => 2
    t.string   "street"
    t.string   "zipcode"
    t.string   "city"
    t.string   "country"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.string   "url"
  end

  add_index "venues", ["latitude", "longitude"], :name => "index_venues_on_latitude_and_longitude"
  add_index "venues", ["region_id"], :name => "index_venues_on_region_id"

end
