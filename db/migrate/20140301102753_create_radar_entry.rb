class CreateRadarEntry < ActiveRecord::Migration
  def change
    create_table :radar_entries do |t|
      t.integer :radar_setting_id
      t.string :entry_id, limit: 255
      t.datetime :entry_date
      t.string :state, limit: 255
      t.text :content
      t.text :previous_confirmed_content
    end
  end
end
