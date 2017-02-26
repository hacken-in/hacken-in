class RemoveActiveAdminComments < ActiveRecord::Migration
  def up
    drop_table :active_admin_comments
  end

  def down
    create_table "active_admin_comments" do |t|
      t.string   "resource_id", limit: 255
      t.string   "resource_type", limit: 255
      t.integer  "author_id"
      t.string   "author_type", limit: 255
      t.text     "body"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "namespace", limit: 255
    end

    add_index "active_admin_comments"
    add_index "active_admin_comments"
    add_index "active_admin_comments"
  end
end
