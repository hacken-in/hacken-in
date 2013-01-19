class AddUseVenueInfoOfEventToSingleEvents < ActiveRecord::Migration
  def change
    add_column :single_events, :use_venue_info_of_event, :boolean, default: true
  end
end
