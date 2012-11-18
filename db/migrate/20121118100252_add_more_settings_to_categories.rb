class AddMoreSettingsToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :blog_category, :boolean, default: true
    add_column :categories, :calendar_category, :boolean, default: true
  end
end
