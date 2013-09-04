class RemoveUnneededSuggestionFields < ActiveRecord::Migration
  def change
    remove_column :suggestions, :name
    remove_column :suggestions, :occurrence
    remove_column :suggestions, :place
    remove_column :suggestions, :more
  end
end
