class CreateCalendarPresetCategories < ActiveRecord::Migration
  def change
    create_table :calendar_preset_categories do |t|
      t.references :category
      t.references :calendar_preset

      t.timestamps
    end

    add_index :calendar_preset_categories, :category_id
    add_index :calendar_preset_categories, :calendar_preset_id
  end
end
