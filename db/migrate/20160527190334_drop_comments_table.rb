class DropCommentsTable < ActiveRecord::Migration
  def change
    drop_table :comments do |t|
      t.text     "body"
      t.integer  "user_id"
      t.integer  "commentable_id"
      t.string   "commentable_type", limit: 255
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end
end
