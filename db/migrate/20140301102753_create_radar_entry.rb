class CreateRadarEntry < ActiveRecord::Migration
  def change
    create_table :radar_entries do |t|
      t.integer :radar_setting_id
      t.integer :entry_id
      t.datetime :entry_date
      t.string :state
      t.text :content
      t.text :previous_confirmed_content
    end
  end
end
