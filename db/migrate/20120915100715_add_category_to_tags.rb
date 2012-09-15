class AddCategoryToTags < ActiveRecord::Migration
  def change
    change_table :tags do |t|
      t.references :category
    end

    add_index :tags, :category_id
  end
end
