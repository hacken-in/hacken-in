class AddPodcastCategorieToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :podcast_category, :boolean, default: false
  end
end
