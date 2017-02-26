class CreateRegions < ActiveRecord::Migration
  def change
    create_table :regions do |t|
      t.string :name, limit: 255
      t.string :slug, limit: 255
      t.float :latitude
      t.float :longitude
      t.float :perimeter, default: 20

      t.timestamps
    end
    add_index :regions, :slug
  end
end
