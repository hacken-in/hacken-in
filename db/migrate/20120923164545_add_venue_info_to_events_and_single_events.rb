class AddVenueInfoToEventsAndSingleEvents < ActiveRecord::Migration
  def change
  	change_table :events do |t|
      t.string :venue_info
    end
    
    change_table :single_events do |t|
      t.string :venue_info
    end
  end
end
