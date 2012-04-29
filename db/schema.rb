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

ActiveRecord::Schema.define(:version => 20120428162856) do

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

  create_table "events", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.text     "schedule_yaml"
    t.string   "url"
    t.string   "twitter"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "location"
    t.string   "street"
    t.string   "zipcode"
    t.string   "city"
    t.string   "country"
    t.float    "latitude"
    t.float    "longitude"
    t.boolean  "full_day",        :default => false
    t.string   "twitter_hashtag"
    t.string   "ical_feed"
    t.string   "ical_pattern"
  end

  add_index "events", ["latitude"], :name => "index_events_on_latitude"
  add_index "events", ["longitude"], :name => "index_events_on_longitude"

  create_table "ical_files", :force => true do |t|
    t.string "md5_hash"
    t.string "url"
  end

  create_table "single_events", :force => true do |t|
    t.string   "topic"
    t.text     "description"
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "occurrence"
    t.string   "url"
    t.integer  "duration"
    t.boolean  "full_day"
    t.string   "location"
    t.string   "street"
    t.string   "zipcode"
    t.string   "city"
    t.string   "country"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "twitter_hashtag"
    t.boolean  "based_on_rule",   :default => false
  end

  add_index "single_events", ["event_id"], :name => "index_single_events_on_event_id"

  create_table "single_events_users", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "single_event_id"
  end

  add_index "single_events_users", ["single_event_id"], :name => "index_single_events_users_on_single_event_id"
  add_index "single_events_users", ["user_id"], :name => "index_single_events_users_on_user_id"

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
    t.string "name"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                               :default => "",    :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin",                               :default => false
    t.string   "nickname",                            :default => "",    :null => false
    t.text     "description"
    t.string   "github"
    t.string   "twitter"
    t.string   "homepage"
    t.string   "guid"
    t.boolean  "allow_ignore_view"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["nickname"], :name => "index_users_on_nickname", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
