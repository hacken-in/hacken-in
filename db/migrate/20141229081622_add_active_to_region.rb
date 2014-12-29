class AddActiveToRegion < ActiveRecord::Migration
  def change
    add_column :regions, :active, :boolean
    Region.update_all(active: true)
  end
end
