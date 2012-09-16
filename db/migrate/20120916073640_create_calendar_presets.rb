class CreateCalendarPresets < ActiveRecord::Migration
  def change
    create_table :calendar_presets do |t|
      t.references :user, null: true
      t.string :title

      t.timestamps
    end

    add_index :calendar_presets, :user_id
  end
end
