class RemoveOldLocationData < ActiveRecord::Migration
  def change
    remove_column :events, :latitude
    remove_column :events, :longitude
    remove_column :events, :location
    remove_column :events, :street
    remove_column :events, :zipcode
    remove_column :events, :city
    remove_column :events, :country
    remove_column :single_events, :latitude
    remove_column :single_events, :longitude
    remove_column :single_events, :location
    remove_column :single_events, :street
    remove_column :single_events, :zipcode
    remove_column :single_events, :city
    remove_column :single_events, :country
  end
end
