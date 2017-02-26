class CreateRadarSettings < ActiveRecord::Migration
  def change
    create_table :radar_settings do |t|
      t.integer :event_id
      t.string :url, limit: 255
      t.string :radar_type, limit: 255
      t.datetime :last_processed
      t.string :last_result, limit: 255
    end
  end
end
