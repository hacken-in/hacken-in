class AddRegionIdToSingleEvent < ActiveRecord::Migration
  def change
    add_column :single_events, :region_id, :integer
    add_index :single_events, :region_id
  end
end
