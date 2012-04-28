class AddFulldayToEvent < ActiveRecord::Migration
  def change
    add_column :events, :full_day, :boolean, default: false
  end
end
