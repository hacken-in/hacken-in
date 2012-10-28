class AddCategoryToEventsAndSingleEvents < ActiveRecord::Migration
  def change
    change_table :events do |t|
      t.references :category
    end

    change_table :single_events do |t|
      t.references :category
    end

    add_index :single_events, :category_id
    add_index :events, :category_id
  end
end
