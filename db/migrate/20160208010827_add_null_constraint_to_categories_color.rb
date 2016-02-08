class AddNullConstraintToCategoriesColor < ActiveRecord::Migration
  def change
    change_column :categories, :color, :string, null: false, default: '#ccc'
  end
end
