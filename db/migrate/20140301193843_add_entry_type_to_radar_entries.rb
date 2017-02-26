class AddEntryTypeToRadarEntries < ActiveRecord::Migration
  def change
    add_column :radar_entries, :entry_type, :string, limit: 255
  end
end
