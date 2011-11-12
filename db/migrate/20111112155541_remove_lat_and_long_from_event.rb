class RemoveLatAndLongFromEvent < ActiveRecord::Migration
  def change
    remove_index "events", ["lat"]
    remove_index "events", ["long"]

    remove_column "events", "lat"
    remove_column "events", "long"

    add_index "events", ["latitude"], :name => "index_events_on_latitude"
    add_index "events", ["longitude"], :name => "index_events_on_longitude"
  end
end
