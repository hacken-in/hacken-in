class AddICalFilesToEvents < ActiveRecord::Migration
  def change
    add_column :events, :ical_file_id, :integer
    remove_column :events, :ical_feed
  end
end
