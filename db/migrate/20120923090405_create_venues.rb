class CreateVenues < ActiveRecord::Migration
  def change
    create_table :venues do |t|
      t.string :location
      t.string :street
      t.string :zipcode
      t.string :city
      t.string :country
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
    
    add_index :venues, [:latitude, :longitude]
  end
end
