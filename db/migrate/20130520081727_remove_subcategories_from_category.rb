class RemoveSubcategoriesFromCategory < ActiveRecord::Migration
  def change
    remove_column :categories, :podcast_category
    remove_column :categories, :blog_category
    remove_column :categories, :calendar_category
    remove_column :categories, :itunes_url
  end
end
