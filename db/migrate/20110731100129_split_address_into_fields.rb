class SplitAddressIntoFields < ActiveRecord::Migration

  def change
    change_table :events do |t|
      t.remove :address
      t.string :location
      t.string :street
      t.string :zipcode
      t.string :city
      t.string :country
      t.float :latitude
      t.float :longitude
    end
  end

end
