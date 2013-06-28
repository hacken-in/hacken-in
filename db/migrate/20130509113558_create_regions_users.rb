class CreateRegionsUsers < ActiveRecord::Migration
  def change
    create_table :regions_users do |t|
      t.references :region
      t.references :user

      t.timestamps
    end
    add_index :regions_users, :region_id
    add_index :regions_users, :user_id
  end
end
