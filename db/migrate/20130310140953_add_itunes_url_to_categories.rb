class AddItunesUrlToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :itunes_url, :string
  end
end
