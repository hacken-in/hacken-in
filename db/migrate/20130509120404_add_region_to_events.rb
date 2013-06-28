class AddRegionToEvents < ActiveRecord::Migration
  def change
    add_column :events, :region_id, :integer, :after => :name
    add_index :events, :region_id
  end
end
