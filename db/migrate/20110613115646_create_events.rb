class CreateEvents < ActiveRecord::Migration
  def change
    create_table "events", :force => true do |t|
      t.string   "name"
      t.text     "address"
      t.text     "description"
      t.text     "schedule_yaml"
      t.string   "url"
      t.string   "twitter"
      t.float    "lat"
      t.float    "long"
      t.timestamps
    end
    add_index "events", "lat"
    add_index "events", "long"
  end
end
