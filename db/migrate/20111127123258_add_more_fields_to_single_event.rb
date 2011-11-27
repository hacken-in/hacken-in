class AddMoreFieldsToSingleEvent < ActiveRecord::Migration
  def change
    add_column :single_events, :url, :string
    add_column :single_events, :duration, :integer
    add_column :single_events, :full_day, :boolean
    add_column :single_events, :location, :string
    add_column :single_events, :street, :string
    add_column :single_events, :zipcode, :string
    add_column :single_events, :city, :string
    add_column :single_events, :country, :string
    add_column :single_events, :latitude, :float
    add_column :single_events, :longitude, :float
   end
end
