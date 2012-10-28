class AddIndices < ActiveRecord::Migration
  def change
    add_index :advertisements, [ :picture_id ]
    add_index :blog_posts,     [ :picture_id ]
    add_index :events,         [ :picture_id ]
    add_index :single_events,  [ :picture_id ]
    add_index :boxes,          [ :content_id, :content_type ]
  end
end
