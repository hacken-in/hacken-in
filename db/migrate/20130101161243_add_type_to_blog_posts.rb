class AddTypeToBlogPosts < ActiveRecord::Migration
  def change
    add_column :blog_posts, :blog_type, :string, default: "blog"
  end
end
