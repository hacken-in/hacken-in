class Reboot < ActiveRecord::Migration
  def change
    create_table "active_admin_comments", :force => true do |t|
      t.string   "resource_id",   null: false
      t.string   "resource_type", null: false
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
      t.string   "provider",      limit: 255
      t.string   "uid",           limit: 255
      t.integer  "user_id"
      t.datetime "created_at",    :null => false
      t.datetime "updated_at",    :null => false
      t.string   "token",         limit: 255
      t.string   "secret",        limit: 255
      t.datetime "token_expires"
      t.string   "temp_token",    limit: 255
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
      t.string   "title", limit: 255
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
    end

    add_index "calendar_presets", ["user_id"], :name => "index_calendar_presets_on_user_id"

    create_table "categories", :force => true do |t|
      t.string   "title",              limit: 255
      t.string   "color",              limit: 255
      t.datetime "created_at",                           :null => false
      t.datetime "updated_at",                           :null => false
      t.boolean  "podcast_category",  :default => false
      t.boolean  "blog_category",     :default => true
      t.boolean  "calendar_category", :default => true
      t.string   "itunes_url",        limit: 255
    end

    create_table "comments", :force => true do |t|
      t.text     "body"
      t.integer  "user_id"
      t.integer  "commentable_id"
      t.string   "commentable_type", limit: 255
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "comments", ["commentable_id", "commentable_type"], :name => "index_comments_on_commentable_id_and_commentable_type"
    add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

    create_table "events", :force => true do |t|
      t.string   "name", limit: 255
      t.text     "description"
      t.text     "schedule_yaml"
      t.string   "url", limit: 255
      t.string   "twitter", limit: 255
      t.datetime "created_at"
      t.datetime "updated_at"
      t.boolean  "full_day",        :default => false
      t.string   "twitter_hashtag", limit: 255
      t.integer  "category_id"
      t.integer  "venue_id"
      t.string   "venue_info", limit: 255
      t.integer  "picture_id"
    end

    add_index "events", ["category_id"], :name => "index_events_on_category_id"
    add_index "events", ["picture_id"], :name => "index_events_on_picture_id"
    add_index "events", ["venue_id"], :name => "index_events_on_venue_id"

    create_table "pictures", :force => true do |t|
      t.string   "title", limit: 255
      t.text     "description"
      t.string   "box_image", limit: 255
      t.datetime "created_at",          :null => false
      t.datetime "updated_at",          :null => false
      t.string   "carousel_image", limit: 255
      t.string   "advertisement_image", limit: 255
    end

    create_table "single_events", :force => true do |t|
      t.string   "name", limit: 255
      t.text     "description"
      t.integer  "event_id"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.datetime "occurrence"
      t.string   "url", limit: 255
      t.integer  "duration"
      t.boolean  "full_day"
      t.string   "twitter_hashtag", limit: 255
      t.boolean  "based_on_rule",           :default => false
      t.integer  "category_id"
      t.integer  "venue_id"
      t.string   "venue_info", limit: 255
      t.integer  "picture_id"
      t.string   "twitter", limit: 255
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
      t.string   "name", limit: 255
      t.string   "occurrence", limit: 255
      t.text     "description"
      t.text     "place"
      t.text     "more"
      t.datetime "created_at",  :null => false
      t.datetime "updated_at",  :null => false
    end

    create_table "taggings", :force => true do |t|
      t.integer  "tag_id"
      t.integer  "taggable_id"
      t.string   "taggable_type", limit: 255
      t.integer  "tagger_id"
      t.string   "tagger_type", limit: 255
      t.string   "context", limit: 255
      t.datetime "created_at"
    end

    add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
    add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"
    add_index "taggings", ["tagger_id", "tagger_type"], :name => "index_taggings_on_tagger_id_and_tagger_type"

    create_table "tags", :force => true do |t|
      t.string  "name", limit: 255
      t.integer "category_id"
    end

    add_index "tags", ["category_id"], :name => "index_tags_on_category_id"

    create_table "thisiscologne_pictures", :force => true do |t|
      t.string   "description", limit: 255
      t.string   "image_url", limit: 255
      t.string   "link", limit: 255
      t.datetime "time"
      t.datetime "created_at",  :null => false
      t.datetime "updated_at",  :null => false
    end

    add_index "thisiscologne_pictures", ["image_url"], :name => "index_thisiscologne_pictures_on_image_url", :unique => true

    create_table "users", :force => true do |t|
      t.string   "email", limit: 255
      t.string   "encrypted_password", limit: 255
      t.string   "reset_password_token", limit: 255
      t.datetime "remember_created_at"
      t.integer  "sign_in_count",          :default => 0
      t.datetime "current_sign_in_at"
      t.datetime "last_sign_in_at"
      t.string   "current_sign_in_ip", limit: 255
      t.string   "last_sign_in_ip", limit: 255
      t.datetime "created_at"
      t.datetime "updated_at"
      t.boolean  "admin",                  :default => false
      t.string   "nickname",               default: "", null: false, limit: 255
      t.text     "description"
      t.string   "github", limit: 255
      t.string   "twitter", limit: 255
      t.string   "homepage", limit: 255
      t.string   "guid", limit: 255
      t.boolean  "allow_ignore_view"
      t.datetime "reset_password_sent_at"
      t.string   "image_url", limit: 255
      t.string   "team", limit: 255
      t.string   "name", limit: 255
    end

    add_index "users", ["email"], :name => "index_users_on_email", :unique => true
    add_index "users", ["nickname"], :name => "index_users_on_nickname", :unique => true
    add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

    create_table "venues", :force => true do |t|
      t.string   "location", limit: 255
      t.string   "street", limit: 255
      t.string   "zipcode", limit: 255
      t.string   "city", limit: 255
      t.string   "country", limit: 255
      t.float    "latitude"
      t.float    "longitude"
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
      t.string   "url", limit: 255
    end

    add_index "venues", ["latitude", "longitude"], :name => "index_venues_on_latitude_and_longitude"
  end
end
