class CreateRegionSlugs < ActiveRecord::Migration
  def change
    create_table :region_slugs do |t|
      t.string :slug, unique: true, index: true, null: false
      t.boolean :main_slug, default: false
      t.references :region, null: false
      t.timestamps null: false
    end
  end
end
