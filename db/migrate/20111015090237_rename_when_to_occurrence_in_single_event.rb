class RenameWhenToOccurrenceInSingleEvent < ActiveRecord::Migration
  def change
    rename_column :single_events, :when, :occurrence
  end
end
