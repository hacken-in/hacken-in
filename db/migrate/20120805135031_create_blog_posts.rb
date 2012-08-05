class CreateBlogPosts < ActiveRecord::Migration
  def change
    create_table :blog_posts do |t|
      t.string :headline
      t.text :headline_teaser
      t.text :teaser_text
      t.text :text

      t.integer :user_id
      t.boolean :publishable
      t.integer :category_id

      t.timestamps
    end
    add_index :blog_posts, :user_id
    add_index :blog_posts, :category_id
  end
end
