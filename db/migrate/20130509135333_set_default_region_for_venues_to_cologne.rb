class SetDefaultRegionForVenuesToCologne < ActiveRecord::Migration
  def up
    change_column :venues, :region_id, :integer, default: 2
    Venue.all.each { |venue| venue.update_attribute(:region_id, 2) }
  end
end
