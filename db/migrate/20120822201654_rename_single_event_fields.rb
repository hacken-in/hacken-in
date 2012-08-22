class RenameSingleEventFields < ActiveRecord::Migration
  def up
    rename_column :single_events, :topic, :name
  end

  def down
    rename_column :single_events, :name, :topic
  end
end
