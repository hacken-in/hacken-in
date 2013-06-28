class RenameRegionsUsersToRegionOrganizers < ActiveRecord::Migration
  def change
    rename_table :regions_users, :region_organizers
  end
end
