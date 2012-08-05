class AddMoreMetadataToBlogpost < ActiveRecord::Migration
  def change
    add_column :blog_posts, :publishable_from, :datetime
    add_column :blog_posts, :use_in_newsletter, :boolean
  end
end
