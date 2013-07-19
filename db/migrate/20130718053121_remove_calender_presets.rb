class RemoveCalenderPresets < ActiveRecord::Migration
  def up
    drop_table :calendar_presets
    drop_table :calendar_preset_categories
  end

  def down
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
  end
end
