class DeleteAllTheThings < ActiveRecord::Migration
  def up
    drop_table :advertisements
    drop_table :blog_posts
    drop_table :boxes
    drop_table :welcome_contents
  end

  def down
  end
end
