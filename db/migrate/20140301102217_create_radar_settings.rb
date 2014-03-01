class CreateRadarSettings < ActiveRecord::Migration
  def change
    create_table :radar_settings do |t|
      t.integer :event_id
      t.string :url
      t.string :radar_type
      t.datetime :last_processed
      t.string :last_result
    end
  end
end
