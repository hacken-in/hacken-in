class AddRegionToVenue < ActiveRecord::Migration
  def change
    add_column :venues, :region_id, :integer, :after => :location
    add_index :venues, :region_id
  end
end
