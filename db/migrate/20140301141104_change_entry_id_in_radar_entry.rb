class ChangeEntryIdInRadarEntry < ActiveRecord::Migration
  def change
    change_column :radar_entries, :entry_id, :string, limit: 255
  end
end
