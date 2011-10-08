class CreateSingleEvents < ActiveRecord::Migration
  def change
    create_table :single_events do |t|
      t.string :topic
      t.text :description
      t.time :time
      t.integer :event_id

      t.timestamps
    end
  end
end
