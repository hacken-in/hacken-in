class RenameUsersEventsToEventCurations < ActiveRecord::Migration
  def change
    rename_table :events_users, :event_curations
  end
end
