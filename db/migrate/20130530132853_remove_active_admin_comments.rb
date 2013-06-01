class RemoveActiveAdminComments < ActiveRecord::Migration
  def up
    drop_table :active_admin_comments
  end

  def down
    create_table "active_admin_comments" do |t|
      t.string   "resource_id"
      t.string   "resource_type"
      t.integer  "author_id"
      t.string   "author_type"
      t.text     "body"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "namespace"
    end

    add_index "active_admin_comments"
    add_index "active_admin_comments"
    add_index "active_admin_comments"
  end
end
