class AddCurrentRegionToUsers < ActiveRecord::Migration
  def change
    add_column :users, :current_region_id, :integer, :after => :nickname, default: 2
  end
end
