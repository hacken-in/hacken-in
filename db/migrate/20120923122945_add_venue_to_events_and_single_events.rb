class AddVenueToEventsAndSingleEvents < ActiveRecord::Migration
  def change
    change_table :events do |t|
      t.references :venue
    end
    
    change_table :single_events do |t|
      t.references :venue
    end
    
    add_index :single_events, :venue_id
    add_index :events, :venue_id
  end
end
