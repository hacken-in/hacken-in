class RenameTimeFieldOfSingleEventToWhen < ActiveRecord::Migration
  def change
    remove_column :single_events, :time
    add_column :single_events, :when, :datetime
  end
end
