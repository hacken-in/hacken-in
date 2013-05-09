class CreateRegions < ActiveRecord::Migration
  def change
    create_table :regions do |t|
      t.string :name
      t.string :slug
      t.float :latitude
      t.float :longitude
      t.float :perimeter, default: 20

      t.timestamps
    end
    add_index :regions, :slug
  end
end
